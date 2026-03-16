const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
  let firestore = admin.firestore();
  let userRef = firestore.doc("users/" + user.uid);
  await firestore
    .collectionGroup("followRequests")
    .where("fromUserId", "==", userRef)
    .get()
    .then(async (querySnapshot) => {
      for (var doc of querySnapshot.docs) {
        console.log(
          `Deleting document ${doc.id} from collection followRequests`,
        );
        await doc.ref.delete();
      }
    });
  await firestore
    .collectionGroup("notifications")
    .where("fromUser", "==", userRef)
    .get()
    .then(async (querySnapshot) => {
      for (var doc of querySnapshot.docs) {
        console.log(
          `Deleting document ${doc.id} from collection notifications`,
        );
        await doc.ref.delete();
      }
    });
  await firestore.collection("users").doc(user.uid).delete();
  await firestore
    .collection("posts")
    .where("postUser", "==", userRef)
    .get()
    .then(async (querySnapshot) => {
      for (var doc of querySnapshot.docs) {
        console.log(`Deleting document ${doc.id} from collection posts`);
        await doc.ref.delete();
      }
    });
  await firestore
    .collection("comments")
    .where("userref", "==", userRef)
    .get()
    .then(async (querySnapshot) => {
      for (var doc of querySnapshot.docs) {
        console.log(`Deleting document ${doc.id} from collection comments`);
        await doc.ref.delete();
      }
    });
  await firestore
    .collection("usernames")
    .where("uid", "==", user.uid)
    .get()
    .then(async (querySnapshot) => {
      for (var doc of querySnapshot.docs) {
        console.log(`Deleting document ${doc.id} from collection usernames`);
        await doc.ref.delete();
      }
    });
  await firestore
    .collection("recipes")
    .where("user_id", "==", userRef)
    .get()
    .then(async (querySnapshot) => {
      for (var doc of querySnapshot.docs) {
        console.log(`Deleting document ${doc.id} from collection recipes`);
        await doc.ref.delete();
      }
    });
});

// Send push notification when a new notification document is created.
exports.sendPushNotification = functions.firestore
  .document("users/{userId}/notifications/{notificationId}")
  .onCreate(async (snap, context) => {
    const notification = snap.data();
    const recipientId = context.params.userId;
    const firestore = admin.firestore();

    // Get the recipient's FCM token.
    const recipientDoc = await firestore.doc(`users/${recipientId}`).get();
    const recipientData = recipientDoc.data();
    if (!recipientData || !recipientData.fcmToken) {
      console.log("No FCM token for recipient", recipientId);
      return null;
    }

    // Get the sender's display name.
    let senderName = "Someone";
    if (notification.fromUser) {
      const senderDoc = await notification.fromUser.get();
      const senderData = senderDoc.data();
      if (senderData && senderData.display_name) {
        senderName = senderData.display_name;
      }
    }

    // Build the notification message based on type.
    let title = "bite";
    let body = "";
    switch (notification.type) {
      case "like":
        body = `${senderName} liked your post`;
        break;
      case "comment":
        body = notification.commentText
          ? `${senderName} commented: ${notification.commentText}`
          : `${senderName} commented on your post`;
        break;
      case "cookedThis":
        body = `${senderName} cooked your recipe`;
        break;
      case "follow":
        body = `${senderName} started following you`;
        break;
      case "followRequest":
        body = `${senderName} requested to follow you`;
        break;
      default:
        body = `${senderName} sent you a notification`;
    }

    const message = {
      token: recipientData.fcmToken,
      notification: { title, body },
      apns: {
        payload: {
          aps: {
            badge: (recipientData.unseenNotifications || 0) + 1,
            sound: "default",
          },
        },
      },
    };

    try {
      await admin.messaging().send(message);
      console.log("Push notification sent to", recipientId);
    } catch (error) {
      console.error("Error sending push notification:", error);
      // If token is invalid, remove it.
      if (
        error.code === "messaging/invalid-registration-token" ||
        error.code === "messaging/registration-token-not-registered"
      ) {
        await firestore
          .doc(`users/${recipientId}`)
          .update({ fcmToken: admin.firestore.FieldValue.delete() });
      }
    }
    return null;
  });
