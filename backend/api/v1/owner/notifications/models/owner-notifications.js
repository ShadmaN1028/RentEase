const connection = require("../../../connection/connection");
const queries = require("../queries/owner-notifications");

const owner_notifications = {
  getNotificationsList: async (owner_id) => {
    try {
      const [notificationsList] = await connection.query(
        queries.getNotificationsList,
        [owner_id]
      );
      return notificationsList;
    } catch (error) {
      console.error("Get notifications error:", error);
      throw error;
    }
  },
  getNotificationDetails: async (owner_id, notification_id) => {
    try {
      const [notificationsDetails] = await connection.query(
        queries.getNotificationDetails,
        [owner_id, notification_id]
      );
      return notificationsDetails;
    } catch (error) {
      console.error("Get notification details error:", error);
      throw error;
    }
  },
  unreadNotifications: async (owner_id) => {
    try {
      const [unreadNotifications] = await connection.query(
        queries.unreadNotifications,
        [owner_id]
      );
      return unreadNotifications;
    } catch (error) {
      console.error("Get unread notifications error:", error);
      throw error;
    }
  },
  getTenancyList: async (owner_id) => {
    try {
      const [tenancyList] = await connection.query(queries.getTenancyList, [
        owner_id,
      ]);
      return tenancyList;
    } catch (error) {
      console.error("Get tenancies error:", error);
      throw error;
    }
  },
  sendNotifications: async (user_id, owner_id, description, recipient_type) => {
    let conn;
    try {
      conn = await connection.getConnection();
      await conn.beginTransaction();
      const [result] = await conn.query(queries.sendNotifications, [
        user_id,
        owner_id,
        description,
        recipient_type, // 'tenant' or 'owner'
        owner_id,
        owner_id,
      ]);
      if (result.affectedRows === 0) {
        throw new Error("sending notification failed");
      }

      await conn.commit();
      return {
        success: true,
        message: "notif sent",
      };
    } catch (error) {
      if (conn) await conn.rollback();
      console.error("notif send error:", error);
      throw error;
    } finally {
      if (conn) conn.release();
    }
  },
  markAsRead: async (owner_id, notification_id) => {
    try {
      const [result] = await connection.query(queries.markAsRead, [
        owner_id,
        notification_id,
      ]);
      if (result.affectedRows === 0) {
        throw new Error("mark as read failed");
      }
      return {
        success: true,
        message: "notif marked as read",
      };
    } catch (error) {
      console.error("mark as read error:", error);
      throw error;
    }
  },
};

module.exports = owner_notifications;
