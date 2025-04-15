const table_name = "tenancies";

const queries = {
  getTenancyList: `
  SELECT 
    t.tenancy_id, 
    u.first_name, 
    u.last_name, 
    f.flat_number, 
    b.building_name, 
    b.address 
  FROM tenancies t 
  JOIN users u ON t.user_id = u.user_id 
  JOIN flats f ON t.flats_id = f.flats_id 
  JOIN building b ON f.building_id = b.building_id
  WHERE t.owner_id = ? AND t.status = 1
`,

  getTenancyDetails: `
SELECT 
  t.*, 
  u.first_name, 
  u.last_name, 
  u.nid, 
  u.contact_number, 
  u.permanent_address, 
  u.user_email,
  f.flat_number 
FROM tenancies t
JOIN users u ON t.user_id = u.user_id
JOIN flats f ON t.flats_id = f.flats_id
WHERE t.owner_id = ? AND t.tenancy_id = ?
`,

  removeTenancy: `UPDATE tenancies 
SET status = 0, last_update_date = CURRENT_TIMESTAMP() 
WHERE owner_id = ? AND tenancy_id = ?
`,
};

module.exports = queries;
