const express = require("express");
const router = express.Router();
const payments = require("../models/tenant-payments");
const { verifyToken } = require("../../../jwt");
const isEmpty = require("is-empty");

// Middleware for authentication
const authenticate = (req, res, next) => {
  const token = req.headers["authorization"]?.split(" ")[1]; // Extract token from authorization header
  if (!token) {
    return res.status(401).json({
      success: false,
      message: "No token provided",
      errorCode: "TOKEN_MISSING", // Custom error code for no token
    });
  }

  try {
    // Verify the token and decode it
    const decoded = verifyToken(token);
    req.user = decoded; // Attach the user info to request object
    next(); // Proceed to the next middleware or route handler
  } catch (e) {
    return res.status(401).json({
      success: false,
      message: "Invalid token", // Detailed message for invalid token
      errorCode: "INVALID_TOKEN", // Custom error code for invalid token
    });
  }
};

// Route to get payment info
router.get("/tenant/payment-info", authenticate, async (req, res) => {
  try {
    const result = await payments.getPaymentInfo(req.user.user_id); // Fetch payment info
    res.status(200).json({ success: true, data: result });
  } catch (e) {
    console.error(e); // Log the error for debugging
    res.status(500).json({
      success: false,
      message: e.message,
      errorCode: "SERVER_ERROR", // Custom error code for server errors
    });
  }
});

// Route to make a payment
router.post("/tenant/pay", authenticate, async (req, res) => {
  try {
    const { amount } = req.body;

    // Validate the amount
    if (!amount || amount <= 0) {
      return res.status(400).json({
        success: false,
        message: "Invalid amount",
        errorCode: "INVALID_AMOUNT", // Custom error code for invalid amount
      });
    }

    // Process the payment
    await payments.makePayment(req.user.user_id, amount);
    res
      .status(200)
      .json({ success: true, message: "Payment processed successfully" });
  } catch (e) {
    console.error(e); // Log the error for debugging
    res.status(500).json({
      success: false,
      message: e.message,
      errorCode: "SERVER_ERROR", // Custom error code for server errors
    });
  }
});

module.exports = router;
