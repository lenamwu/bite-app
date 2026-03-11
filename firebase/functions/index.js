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
