const connection = require("../../../connection/connection");
const queries = require("../queries/tenant-tenancy");

const tenant_tenancies = {
  checkTenancy: async (user_id) => {
    try {
      const [result] = await connection.query(queries.checkTenancy, [user_id]);
      return result;
    } catch (error) {
      console.error("Check tenancy error:", error);
      throw error;
    }
  },
  getTenancyInfo: async (user_id) => {
    try {
      const [result] = await connection.query(queries.getTenancyInfo, [
        user_id,
      ]);
      return result;
    } catch (error) {
      console.error("Check tenancy error:", error);
      throw error;
    }
  },
  leaveTenancy: async (user_id) => {
    let conn;
    try {
      conn = await connection.getConnection();
      await conn.beginTransaction();

      // Step 1: Get tenancy_id
      const [tenancyResult] = await conn.query(
        `SELECT tenancy_id FROM tenancies WHERE user_id = ? AND status = 1 LIMIT 1`,
        [user_id]
      );
      const tenancy_id = tenancyResult?.[0]?.tenancy_id;

      if (!tenancy_id) throw new Error("No active tenancy found");

      // Step 2: Delete related payments
      await conn.query(`DELETE FROM payments WHERE tenancy_id = ?`, [
        tenancy_id,
      ]);

      // Step 3: Update flat status and building vacancy
      await conn.query(queries.updateFlatStatus, [user_id]);
      await conn.query(queries.updateVacancies, [user_id]);

      // Step 4: Update tenancy status
      await conn.query(queries.leaveTenancy, [user_id]);

      await conn.commit();
      return { success: true };
    } catch (error) {
      if (conn) await conn.rollback();
      console.error("Leave tenancy error:", error);
      throw error;
    } finally {
      if (conn) conn.release();
    }
  },
};

module.exports = tenant_tenancies;
