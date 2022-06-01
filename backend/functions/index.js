/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const database = admin.firestore();

// decrease budget when user create bought item
const boughtPath = "budget-management/{userId}/budget/{month}/bought/{itemId}";
exports.onBoughtItemCreate = functions.firestore.document(boughtPath).onCreate((snap, context)=>{
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
      functions.logger.info("No such document!");
    }
  });
});

const wishPath = "budget-management/{userId}/wishlist/{itemId}";
exports.onWishItemCreate = functions.firestore.document(wishPath).onCreate((snap, context)=>{
  const price = snap.data().price;
  database.doc("analytics/wishlist").get().then((doc) => {
    functions.logger.info("Increase wishlist price from " + doc.data().price +" to " + doc.data().price+price);
    database.doc("analytics/wishlist").update({count: doc.data().count+1, price: doc.data().price+price});
  });
});

exports.scheduledComputeRatio = functions.pubsub.schedule("every 1 hour").onRun((context) => {
  console.log("start computing ratio prices of budget and wishlist");
  database.doc("analytics/wishlist").get().then((wishDoc) => {
    database.doc("analytics/bought").get().then((boughtDoc) => {
      console.log(`${boughtDoc.data().price} ${wishDoc.data().price}`);
      database.doc("analytics/ratio").update({bought_wishlist: boughtDoc.data().price/wishDoc.data().price});
    });
  });
});
// https://us-central1-budget-management-chen.cloudfunctions.net/getAnalytics
// curl -X POST -H "api-key: 3f850688-992c-477d-9af3-05efcc0383ba" -d "" https://us-central1-budget-management-chen.cloudfunctions.net/getAnalytics
exports.getAnalytics = functions.https.onRequest((req, res) => {
  // Grab the text parameter.
  const apiKey = req.get("api-key");
  console.log(apiKey);
  if (apiKey == "3f850688-992c-477d-9af3-05efcc0383ba") {
    database.doc("analytics/wishlist").get().then((wishDoc) => {
      database.doc("analytics/bought").get().then((boughtDoc) => {
        database.doc("analytics/ratio").get().then((ratioDoc) => {
          database.doc("analytics/launch").get().then((launchDoc) => {
            // const resDict = {};
            const message = `
            The application has been started ${launchDoc.data().count} tiems
            ${boughtDoc.data().count} bought items are created with $${boughtDoc.data().price} price in total
            ${wishDoc.data().count} wish items are created with $${wishDoc.data().price} price in total
            The ratio of total prices in bough items to total prices in wishlist ${ratioDoc.data().bought_wishlist}\n
            `;
            res.status(200).send(message);
          });
        });
      });
    });
  } else {
    res.status(401).send("wrong api key");
  }
});

// functions.logger.info("Hello logs!", {structuredData: true});

