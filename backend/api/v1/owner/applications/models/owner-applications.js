const connection = require("../../../connection/connection");
const queries = require("../queries/owner-applications");

const owner_applications = {
  getPendingApplications: async (owner_id) => {
    try {
      const [applications] = await connection.query(
        queries.getPendingApplications,
        [owner_id]
      );
      return applications;
    } catch (error) {
      console.error("Get applications error:", error);
      throw error;
    }
  },
  approveApplication: async (applications_id, owner_id) => {
    let conn;
    try {
      conn = await connection.getConnection();
      await conn.beginTransaction();

      // 1. Approve the application
      const [approveResult] = await conn.query(queries.approveApplication, [
        applications_id,
        owner_id,
      ]);

      if (approveResult.affectedRows === 0) {
        await conn.rollback();
        return {
          success: false,
          message: "Application not found or already approved",
          statusCode: 404,
        };
      }

      // 2. Get application details
      const [applicationDetails] = await conn.query(
        "SELECT flats_id, user_id, building_id FROM applications WHERE applications_id = ?",
        [applications_id]
      );

      if (applicationDetails.length === 0) {
        await conn.rollback();
        return {
          success: false,
          message: "Application details not found",
          statusCode: 404,
        };
      }

      const { flats_id, user_id, building_id } = applicationDetails[0];

      // 3. Check for existing tenancy
      const [existingTenancy] = await conn.query(queries.checkExistingTenancy, [
        user_id,
      ]);
      if (existingTenancy[0].count > 0) {
        await conn.rollback();
        return {
          success: false,
          message: "User already has an active tenancy",
          statusCode: 400,
        };
      }

      // 4. Update flat status
      await conn.query(queries.updateFlatStatus, [flats_id]);

      // 5. Update building vacancies
      await conn.query(queries.updateVacancies, [building_id, owner_id]);

      // 6. Remove other applications for this user
      await conn.query(queries.removeApplications, [user_id]);

      // 7. Start tenancy
      const [startTenancyResult] = await conn.query(queries.startTenancy, [
        flats_id,
        // flat_number,
        user_id,
        owner_id,
        owner_id, // created_by
        owner_id, // updated_by
        user_id, // for the WHERE NOT EXISTS clause
      ]);

      if (startTenancyResult.affectedRows === 0) {
        await conn.rollback();
        return {
          success: false,
          message:
            "Failed to start tenancy. User may already have an active tenancy.",
          statusCode: 400,
        };
      }

      // 8. Get flat details for notification
      const [flatDetails] = await conn.query(queries.getFlatDetails, [
        flats_id,
      ]);
      if (flatDetails.length === 0) {
        await conn.rollback();
        return {
          success: false,
          message: "Flat details not found",
          statusCode: 404,
        };
      }

      const { flat_number, building_name } = flatDetails[0];

      // 9. Send notification to tenant
      const notificationDescription = `Your application for Flat ${flat_number} in ${building_name} has been approved. Your tenancy starts now.`;
      await conn.query(queries.sendNotification, [
        user_id,
        owner_id,
        notificationDescription,
        "tenant", // <- This is already correctly set to "tenant"
        owner_id, // created_by
        owner_id, // updated_by
      ]);

      await conn.commit();
      return {
        success: true,
        message: "Application approved, tenancy started, and tenant notified",
        statusCode: 200,
      };
    } catch (error) {
      if (conn) await conn.rollback();
      console.error("Approve application error:", error);
      return {
        success: false,
        message: "Internal server error",
        statusCode: 500,
      };
    } finally {
      if (conn) conn.release();
    }
  },

  denyApplication: async (applications_id, owner_id) => {
    try {
      const [denyResult] = await connection.query(queries.denyApplication, [
        applications_id,
        owner_id,
      ]);

      if (denyResult.affectedRows === 0) {
        throw new Error("Application not found or already denied");
      }

      return {
        success: true,
        message: "Application denied successfully",
      };
    } catch (error) {
      console.error("Deny application error:", error);
      throw error;
    }
  },
  removeApplications: async (user_id) => {
    try {
      const [result] = await connection.query(queries.removeApplications, [
        user_id,
      ]);
      return result;
    } catch (error) {
      console.error("Delete application error:", error);
      throw error;
    }
  },
  getTenantDetails: async (tenantId) => {
    try {
      const [rows] = await connection.query(queries.getTenantDetails, [
        tenantId,
      ]);
      return rows[0]; // Expecting one row
    } catch (error) {
      console.error("Error fetching tenant details:", error);
      throw error;
    }
  },
};

module.exports = owner_applications;
