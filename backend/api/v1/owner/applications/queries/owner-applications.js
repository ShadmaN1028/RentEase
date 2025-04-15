const table_name = "applications";
const notifications_table = "notifications";

const queries = {
  getPendingApplications: `
  SELECT 
    a.applications_id,
    a.flats_id,
    a.user_id,
    f.flat_number,
    f.rent,
    f.rooms,
    f.bath,
    f.balcony,
    f.area,
    f.tenancy_type,
    f.description,
    b.building_name,
    a.status
  FROM ${table_name} a
  JOIN flats f ON a.flats_id = f.flats_id
  JOIN building b ON f.building_id = b.building_id
  WHERE a.status = 0 AND a.owner_id = ?
`,
  approveApplication: `UPDATE ${table_name} SET status = 1 WHERE applications_id = ? AND owner_id = ?`,
  denyApplication: `UPDATE ${table_name} SET status = 2 WHERE applications_id = ? AND owner_id = ?`,
  removeApplications: `DELETE FROM ${table_name} WHERE user_id = ?`,
  updateFlatStatus: `UPDATE flats SET status = 1 WHERE flats_id = ?`,
  updateVacancies: `UPDATE building SET vacant_flats = vacant_flats - 1 WHERE building_id = ? AND owner_id = ?`,
  checkExistingTenancy: `SELECT COUNT(*) as count FROM tenancies WHERE user_id = ? AND status = 1`,
  startTenancy: `
    INSERT INTO tenancies (flats_id, user_id, owner_id, start_date, end_date, status, created_by, creation_date, last_updated_by, last_update_date, change_number) 
    SELECT ?, ?, ?, CURRENT_TIMESTAMP(), DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL 2 MONTH), 1, ?, CURRENT_TIMESTAMP(), ?, CURRENT_TIMESTAMP(), 1
    WHERE NOT EXISTS (
      SELECT 1 FROM tenancies WHERE user_id = ? AND status = 1
    )
  `,
  sendNotification: `INSERT INTO notifications 
  (user_id, owner_id, description, status, recipient_type, created_by, creation_date, last_updated_by, last_update_date, change_number)
VALUES 
  (?, ?, ?, 0, ?, ?, CURRENT_TIMESTAMP(), ?, CURRENT_TIMESTAMP(), 1)`,
  getFlatDetails: `
    SELECT f.flat_number, b.building_name
    FROM flats f
    JOIN building b ON f.building_id = b.building_id
    WHERE f.flats_id = ?
  `,
  getTenantDetails: `
  SELECT 
    user_email, first_name, last_name, nid, permanent_address, contact_number, occupation, creation_date 
  FROM users 
  WHERE user_id = ?
`,
};

module.exports = queries;
