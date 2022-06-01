/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const database = admin.firestore();

// decrease budget when user create bought item
const boughtCreatePath = "budget-management/{userId}/budget/{month}/bought/{itemId}";
exports.onBoughtItemCreate = functions.firestore.document(boughtCreatePath).onCreate((snap, context)=>{
  const data = snap.data();
  const userId = context.params.userId;
  const month = context.params.month;
  const budgetPath = "budget-management/" + userId + "/budget";
  database.collection(budgetPath).doc(month).get().then((doc) => {
    if (doc.exists) {
      functions.logger.info("Document data:", doc.data());
      const budgetData = doc.data();
      const current = budgetData.current - data.price;
      functions.logger.info(`${userId} create bought item ${data.price}, decrease budget from ${budgetData.current} to ${budgetData.current - data.price}`);
      database.doc(budgetPath+"/"+month).update({current: current});
      database.doc("analytics/bought").get().then((doc) => {
        database.doc("analytics/bought").update({count: doc.data().count+1, price: doc.data().price+data.price});
      });
    } else {
      // doc.data() will be undefined in this case
      functions.logger.info("No such document!");
    }
  });
});

// functions.logger.info("Hello logs!", {structuredData: true});

