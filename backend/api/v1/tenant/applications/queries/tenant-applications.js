const table_name = "applications";
const flats_table = "flats";
const building_table = "building";
const tenancies_table = "tenancies";
const notifications_table = "notifications";

const queries = {
  checkExistingApplication: `SELECT * FROM ${table_name} WHERE user_id = ? AND flats_id = ?`,
  makeApplications: `
    INSERT INTO ${table_name} (flats_id, building_id, user_id, owner_id, status, created_by, creation_date, last_updated_by, last_update_date, change_number)
    SELECT ?, f.building_id, ?, b.owner_id, 0, ?, CURRENT_TIMESTAMP(), ?, CURRENT_TIMESTAMP(), 1
    FROM ${flats_table} f
    JOIN ${building_table} b ON f.building_id = b.building_id
    WHERE f.flats_id = ?
  `,
  checkApplications: `
  SELECT 
    a.*, 
    f.flat_number, f.rent, f.rooms, f.bath, f.balcony, f.area, 
    f.tenancy_type, f.description, 
    b.building_name
  FROM ${table_name} a
  JOIN ${flats_table} f ON a.flats_id = f.flats_id
  JOIN ${building_table} b ON f.building_id = b.building_id
  WHERE a.user_id = ?
  ORDER BY a.creation_date DESC
`,

  checkTenancy: `SELECT * FROM ${tenancies_table} WHERE user_id = ? AND status = 1`,
  sendNotification: `  INSERT INTO notifications 
    (user_id, owner_id, description, status, recipient_type, created_by, creation_date, last_updated_by, last_update_date, change_number)
  VALUES 
    (?, ?, ?, 0, ?, ?, CURRENT_TIMESTAMP(), ?, CURRENT_TIMESTAMP(), 1)
`,
  getOwnerIdFromFlat: `
    SELECT b.owner_id, b.building_name, f.flat_number
    FROM ${flats_table} f
    JOIN ${building_table} b ON f.building_id = b.building_id
    WHERE f.flats_id = ?
  `,
};

module.exports = queries;
