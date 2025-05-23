const table_name = "notifications";

const queries = {
  getTenancyList: `SELECT t.*, u.first_name, u.last_name, f.flat_number FROM tenancies t join users u on t.user_id = u.user_id join flats f on t.flats_id = f.flats_id WHERE t.owner_id = ? AND t.status = 1 `,
  sendNotifications: `
  INSERT INTO notifications (user_id, owner_id, description, status, recipient_type, created_by, creation_date, last_updated_by, last_update_date, change_number)
  VALUES (?, ?, ?, 0, ?, ?, CURRENT_TIMESTAMP(), ?, CURRENT_TIMESTAMP(), 1)
`,
  getNotificationsList: `
SELECT 
  n.*, 
  u.first_name, 
  u.last_name, 
  f.flat_number 
FROM notifications n
LEFT JOIN users u ON n.user_id = u.user_id
LEFT JOIN tenancies t ON n.user_id = t.user_id
LEFT JOIN flats f ON t.flats_id = f.flats_id
WHERE n.owner_id = ? AND n.recipient_type = 'owner'
ORDER BY n.creation_date DESC
`,
  getNotificationDetails: `SELECT ${table_name}.*, u.first_name, u.last_name, f.flat_number FROM ${table_name} join users u on ${table_name}.user_id = u.user_id join tenancies t on ${table_name}.user_id = t.user_id join flats f on t.flats_id = f.flats_id WHERE owner_id = ? AND notification_id = ?`,
  markAsRead: `UPDATE ${table_name} SET status = 1, last_update_date = CURRENT_TIMESTAMP(), change_number = change_number + 1 WHERE owner_id = ? AND notification_id = ?`,
  unreadNotifications: `SELECT * FROM ${table_name} WHERE owner_id = ? AND status = 0`,
};

module.exports = queries;
