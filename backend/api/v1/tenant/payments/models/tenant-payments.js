const connection = require("../../../connection/connection");
const queries = require("../queries/tenant-payments");

const tenant_payments = {
  getPaymentInfo: async (user_id) => {
    const [result] = await connection.query(queries.getTenantPaymentInfo, [
      user_id,
    ]);
    return result[0];
  },
  makePayment: async (user_id, amount) => {
    const [tenancyRow] = await connection.query(queries.getTenantTenancyId, [
      user_id,
    ]);
    if (tenancyRow.length === 0) throw new Error("No active tenancy");
    const tenancy_id = tenancyRow[0].tenancy_id;

    const [ownerRes] = await connection.query(
      `SELECT owner_id FROM tenancies WHERE tenancy_id = ?`,
      [tenancy_id]
    );
    const owner_id = ownerRes[0].owner_id;

    await connection.query(queries.insertTenantPayment, [
      owner_id,
      tenancy_id,
      amount,
      user_id,
      user_id,
    ]);
    return { message: "Payment successful" };
  },
};

module.exports = tenant_payments;
