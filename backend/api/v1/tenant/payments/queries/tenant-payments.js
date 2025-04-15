const table_name = "payments";

const queries = {
  getTenantPaymentInfo: `
    SELECT f.rent, f.flat_number, f.flats_id, b.building_name, b.address, SUM(p.amount) AS total_paid
    FROM tenancies t
    JOIN flats f ON t.flats_id = f.flats_id
    JOIN building b ON f.building_id = b.building_id
    LEFT JOIN ${table_name} p ON p.tenancy_id = t.tenancy_id
    WHERE t.user_id = ? AND t.status = 1
    GROUP BY f.rent, f.flat_number, f.flats_id, b.building_name, b.address
  `,
  getTenantTenancyId: `
    SELECT tenancy_id FROM tenancies WHERE user_id = ? AND status = 1
  `,
  insertTenantPayment: `
    INSERT INTO ${table_name} (owner_id, tenancy_id, amount, payment_date, payment_type, status, created_by, creation_date, last_updated_by, last_update_date, change_number)
    VALUES (?, ?, ?, CURRENT_TIMESTAMP(), 1, 1, ?, CURRENT_TIMESTAMP(), ?, CURRENT_TIMESTAMP(), 1)
  `,
};
module.exports = queries;
