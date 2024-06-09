const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.easypayIPN = functions.https.onRequest((req, res) => {
    const data = req.body;
    console.log('IPN received:', data); // Log the received IPN data

    const reference = data.reference;  // Order ID
    const reason = data.reason;        // Reason for the transaction
    const txid = data.transactionId;   // Easypay transaction ID
    const amount = data.amount;        // Amount deposited
    const phone = data.phone;          // Phone number that deposited

    // Log the details
    console.log(`Reference: ${reference}`);
    console.log(`Reason: ${reason}`);
    console.log(`Transaction ID: ${txid}`);
    console.log(`Amount: ${amount}`);
    console.log(`Phone: ${phone}`);

    // Return a 200 status to acknowledge the receipt of the IPN
    res.status(200).send('IPN received');
});
