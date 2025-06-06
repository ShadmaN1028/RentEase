const table_name = "users";
const flats_table = "flats";

const queries = {
  getTenantInfo: `SELECT user_email, first_name, last_name, nid, permanent_address, contact_number, occupation, creation_date FROM ${table_name} WHERE user_id = ?`,
  getAvailableFlats: `SELECT f.*, b.building_name FROM flats f JOIN building b ON f.building_id = b.building_id WHERE f.status = 0 ORDER BY f.creation_date DESC`,
  searchFlats: `SELECT f.*, b.building_name, b.address, b.parking, o.first_name, o.last_name from flats f JOIN building b ON f.building_id = b.building_id JOIN owners o ON b.owner_id = o.owner_id WHERE f.status = 0 AND (f.area LIKE ? OR f.rooms LIKE ? OR f.bath LIKE ? OR f.balcony LIKE ? OR f.rent LIKE ? OR f.tenancy_type LIKE ? OR b.building_name LIKE ? OR b.address LIKE ?)  ORDER BY f.creation_date DESC`,
  getFlatDetails: `SELECT f.flats_id, f.flat_number, f.area, f.rooms, f.bath, f.balcony, f.description, f.rent, f.tenancy_type, b.building_name, b.address, b.parking FROM flats f JOIN building b ON f.building_id = b.building_id WHERE f.flats_id = ?`,
};

module.exports = queries;
