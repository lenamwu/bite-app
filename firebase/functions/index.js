const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

/**
 * Extract a Firebase Storage file path from a download URL.
 */
function storagePathFromUrl(url) {
  try {
    const match = url.match(/\/o\/(.+?)\?/);
    if (match) return decodeURIComponent(match[1]);
  } catch (e) {}
  return null;
}

/**
 * Delete a list of Firebase Storage files by their download URLs.
 */
async function deleteStorageFiles(storage, urls) {
  const deletions = [];
  for (const url of urls) {
    if (!url) continue;
    const filePath = storagePathFromUrl(url);
    if (filePath) {
      deletions.push(
        storage.file(filePath).delete().catch((err) => {
          console.error(`Failed to delete storage file ${filePath}:`, err.message);
        })
      );
    }
  }
  await Promise.all(deletions);
}

exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
  let firestore = admin.firestore();
  let userRef = firestore.doc("users/" + user.uid);
  let storage = admin.storage().bucket();

  // Delete user's uploaded files from Firebase Storage
  try {
    const [files] = await storage.getFiles({ prefix: `users/${user.uid}/uploads/` });
    for (const file of files) {
      await file.delete();
    }
    console.log(`Deleted ${files.length} storage files for user ${user.uid}`);
  } catch (error) {
    console.error("Error deleting storage files:", error);
  }

  // Delete follow requests from this user
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

  // Delete notifications sent by this user
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

  // Delete user document
  await firestore.collection("users").doc(user.uid).delete();

  // Delete user's posts, their comments, notifications, and images
  try {
    const postsSnapshot = await firestore
      .collection("posts")
      .where("postUser", "==", userRef)
      .get();

    for (const postDoc of postsSnapshot.docs) {
      const postData = postDoc.data();
      const postRef = postDoc.ref;

      // Delete all comments on this post
      const postCommentsSnapshot = await firestore
        .collection("comments")
        .where("postref", "==", postRef)
        .get();
      const commentBatch = firestore.batch();
      postCommentsSnapshot.docs.forEach((commentDoc) => {
        commentBatch.delete(commentDoc.ref);
      });
      await commentBatch.commit();
      console.log(`Deleted ${postCommentsSnapshot.size} comments for post ${postDoc.id}`);

      // Delete all notifications referencing this post
      const postNotificationsSnapshot = await firestore
        .collectionGroup("notifications")
        .where("post", "==", postRef)
        .get();
      const notifBatch = firestore.batch();
      postNotificationsSnapshot.docs.forEach((notifDoc) => {
        notifBatch.delete(notifDoc.ref);
      });
      await notifBatch.commit();
      console.log(`Deleted ${postNotificationsSnapshot.size} notifications for post ${postDoc.id}`);

      // Delete post images from Storage
      const imageUrls = [];
      if (postData.postMultPhotos && Array.isArray(postData.postMultPhotos)) {
        imageUrls.push(...postData.postMultPhotos);
      }
      if (postData.postImage) {
        imageUrls.push(postData.postImage);
      }
      await deleteStorageFiles(storage, imageUrls);

      // Delete the post itself
      await postRef.delete();
      console.log(`Deleted post ${postDoc.id}`);
    }
  } catch (error) {
    console.error("Error deleting user posts and related data:", error);
  }

  // Delete comments authored by this user
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

  // Delete usernames
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

  // Delete user's recipes and their comments
  try {
    const recipesSnapshot = await firestore
      .collection("recipes")
      .where("user_id", "==", userRef)
      .get();

    for (const recipeDoc of recipesSnapshot.docs) {
      const recipeRef = recipeDoc.ref;

      // Delete all comments on this recipe
      const recipeCommentsSnapshot = await firestore
        .collection("comments")
        .where("reciperef", "==", recipeRef)
        .get();
      const batch = firestore.batch();
      recipeCommentsSnapshot.docs.forEach((commentDoc) => {
        batch.delete(commentDoc.ref);
      });
      await batch.commit();
      console.log(`Deleted ${recipeCommentsSnapshot.size} comments for recipe ${recipeDoc.id}`);

      // Delete the recipe itself
      await recipeRef.delete();
      console.log(`Deleted recipe ${recipeDoc.id}`);
    }
  } catch (error) {
    console.error("Error deleting user recipes and related data:", error);
  }

  // Remove deleted user from other users' following_users and users_following_me arrays
  try {
    const followingSnapshot = await firestore
      .collection("users")
      .where("following_users", "array-contains", userRef)
      .get();
    await Promise.all(
      followingSnapshot.docs.map((doc) =>
        doc.ref.update({
          following_users: admin.firestore.FieldValue.arrayRemove(userRef),
        })
      )
    );
    console.log(`Removed user from ${followingSnapshot.size} following_users arrays`);

    const followersSnapshot = await firestore
      .collection("users")
      .where("users_following_me", "array-contains", userRef)
      .get();
    await Promise.all(
      followersSnapshot.docs.map((doc) =>
        doc.ref.update({
          users_following_me: admin.firestore.FieldValue.arrayRemove(userRef),
        })
      )
    );
    console.log(`Removed user from ${followersSnapshot.size} users_following_me arrays`);
  } catch (error) {
    console.error("Error cleaning up follow relationships:", error);
  }

  // Delete user's drafts
  await firestore
    .collection("drafts")
    .where("user_id", "==", userRef)
    .get()
    .then(async (querySnapshot) => {
      for (var doc of querySnapshot.docs) {
        console.log(`Deleting document ${doc.id} from collection drafts`);
        await doc.ref.delete();
      }
    });

  // Delete user's own subcollections (notifications TO them, follow requests TO them, grocery list)
  const subcollections = ["notifications", "followRequests", "grocery_list"];
  for (const sub of subcollections) {
    await firestore
      .collection("users")
      .doc(user.uid)
      .collection(sub)
      .get()
      .then(async (querySnapshot) => {
        for (var doc of querySnapshot.docs) {
          console.log(`Deleting document ${doc.id} from subcollection ${sub}`);
          await doc.ref.delete();
        }
      });
  }
});

/**
 * When a post is deleted, clean up its comments, notifications, images,
 * and linked recipe.
 */
exports.onPostDeleted = functions.firestore
  .document("posts/{postId}")
  .onDelete(async (snap, context) => {
    const firestore = admin.firestore();
    const storage = admin.storage().bucket();
    const postData = snap.data();
    const postRef = snap.ref;

    // Delete all comments on this post
    try {
      const commentsSnapshot = await firestore
        .collection("comments")
        .where("postref", "==", postRef)
        .get();
      const batch = firestore.batch();
      commentsSnapshot.docs.forEach((doc) => {
        batch.delete(doc.ref);
      });
      await batch.commit();
      console.log(`Deleted ${commentsSnapshot.size} comments for post ${context.params.postId}`);
    } catch (error) {
      console.error("Error deleting post comments:", error);
    }

    // Delete all notifications referencing this post
    try {
      const notificationsSnapshot = await firestore
        .collectionGroup("notifications")
        .where("post", "==", postRef)
        .get();
      const batch = firestore.batch();
      notificationsSnapshot.docs.forEach((doc) => {
        batch.delete(doc.ref);
      });
      await batch.commit();
      console.log(`Deleted ${notificationsSnapshot.size} notifications for post ${context.params.postId}`);
    } catch (error) {
      console.error("Error deleting post notifications:", error);
    }

    // Delete post images from Storage
    try {
      const imageUrls = [];
      if (postData.postMultPhotos && Array.isArray(postData.postMultPhotos)) {
        imageUrls.push(...postData.postMultPhotos);
      }
      if (postData.postImage) {
        imageUrls.push(postData.postImage);
      }
      await deleteStorageFiles(storage, imageUrls);
      console.log(`Deleted ${imageUrls.length} images for post ${context.params.postId}`);
    } catch (error) {
      console.error("Error deleting post images:", error);
    }

    // If the post has a linked recipe, only delete it if it was created inline (post_only)
    if (postData.recipeRef) {
      try {
        const recipeDoc = await postData.recipeRef.get();
        if (recipeDoc.exists) {
          const recipeData = recipeDoc.data();

          if (recipeData.post_only === true) {
            // Delete recipe images from Storage
            if (recipeData.recipe_images && Array.isArray(recipeData.recipe_images)) {
              await deleteStorageFiles(storage, recipeData.recipe_images);
              console.log(`Deleted ${recipeData.recipe_images.length} recipe images`);
            }

            // Delete the recipe document
            await postData.recipeRef.delete();
            console.log(`Deleted linked post_only recipe ${postData.recipeRef.id}`);
          } else {
            console.log(`Skipping recipe ${postData.recipeRef.id} — not post_only, belongs to user's cookbook`);
          }
        }
      } catch (error) {
        console.error("Error deleting linked recipe:", error);
      }
    }

    return null;
  });

/**
 * Scheduled function: delete notifications older than 30 days.
 * Runs once every 24 hours.
 */
exports.scheduledNotificationCleanup = functions.pubsub
  .schedule("every 24 hours")
  .onRun(async (context) => {
    const firestore = admin.firestore();
    const cutoff = admin.firestore.Timestamp.fromDate(
      new Date(Date.now() - 30 * 24 * 60 * 60 * 1000)
    );

    try {
      const usersSnapshot = await firestore.collection("users").get();
      let totalDeleted = 0;

      for (const userDoc of usersSnapshot.docs) {
        const oldNotificationsSnapshot = await firestore
          .collection("users")
          .doc(userDoc.id)
          .collection("notifications")
          .where("createdAt", "<", cutoff)
          .get();

        if (oldNotificationsSnapshot.empty) continue;

        let batch = firestore.batch();
        let batchCount = 0;

        for (const notifDoc of oldNotificationsSnapshot.docs) {
          batch.delete(notifDoc.ref);
          batchCount++;
          totalDeleted++;

          if (batchCount >= 500) {
            await batch.commit();
            batch = firestore.batch();
            batchCount = 0;
          }
        }

        if (batchCount > 0) {
          await batch.commit();
        }
      }

      console.log(`Scheduled cleanup: deleted ${totalDeleted} old notifications`);
    } catch (error) {
      console.error("Error in scheduled notification cleanup:", error);
    }

    return null;
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
