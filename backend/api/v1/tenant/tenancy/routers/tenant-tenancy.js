const express = require("express");
const router = express.Router();
const tenancy = require("../models/tenant-tenancy");

const { verifyToken } = require("../../../jwt");
const isEmpty = require("is-empty");

const authenticateUser = (req, res, next) => {
  const token = req.headers["authorization"]?.split(" ")[1];
  if (!token) {
    return res.status(401).json({ success: false, message: "No token found" });
  }
  try {
    const decoded = verifyToken(token);
    if (decoded) {
      req.user = decoded;
      next();
    } else {
      return res.status(401).json({ success: false, message: "Invalid token" });
    }
  } catch (error) {
    console.error("Error verifying token:", error);
    return res
      .status(500)
      .json({ success: false, message: "Internal server error" });
  }
};

router.get("/tenant/check-tenancy", authenticateUser, async (req, res) => {
  try {
    if (isEmpty(req.user.user_id)) {
      return res.status(401).json({ success: false, message: "Unauthorized" });
    }

    const user_id = req.user.user_id;
    const result = await tenancy.checkTenancy(user_id);

    return res.status(200).json({
      success: true,
      message: "Tenancy retrieved successfully",
      data: result,
    });
  } catch (error) {
    console.error("Error checking tenancy:", error);
    return res
      .status(500)
      .json({ success: false, message: "Internal server error" });
  }
});
router.get(
  "/owner/tenant-details/:tenant_id",
  authenticateUser,
  async (req, res) => {
    const { user_id } = req.params;
    try {
      const tenantDetails = await connection.query(
        `SELECT first_name, last_name, user_email, contact_number, nid, occupation, permanent_address, creation_date 
       FROM users 
       WHERE user_id = ?`,
        [user_id]
      );

      if (tenantDetails[0].length === 0) {
        return res
          .status(404)
          .json({ success: false, message: "Tenant not found" });
      }

      return res.status(200).json({
        success: true,
        data: tenantDetails[0][0],
      });
    } catch (error) {
      console.error("Error fetching tenant details:", error);
      return res
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  }
);

router.get("/tenant/get-tenancy-info", authenticateUser, async (req, res) => {
  try {
    if (isEmpty(req.user.user_id)) {
      return res.status(401).json({ success: false, message: "Unauthorized" });
    }

    const user_id = req.user.user_id;
    const result = await tenancy.getTenancyInfo(user_id);

    if (!result || result.length === 0) {
      return res.status(200).json({
        success: true,
        message: "No active tenancy found",
        data: null,
      });
    }

    return res.status(200).json({
      success: true,
      message: "Tenancy info retrieved successfully",
      data: result[0], // ✅ return single object
    });
  } catch (error) {
    console.error("Error checking tenancy info:", error);
    return res
      .status(500)
      .json({ success: false, message: "Internal server error" });
  }
});

router.delete("/tenant/leave-tenancy", authenticateUser, async (req, res) => {
  try {
    if (isEmpty(req.user.user_id)) {
      return res.status(401).json({ success: false, message: "Unauthorized" });
    }

    const user_id = req.user.user_id;
    const result = await tenancy.leaveTenancy(user_id);

    return res.status(200).json({
      success: true,
      message: "Tenancy deleted successfully",
      data: result,
    });
  } catch (error) {
    console.error("Error leaving tenancy:", error);
    return res
      .status(500)
      .json({ success: false, message: "Internal server error" });
  }
});

module.exports = router;
