import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';


Future<void> _getContactsPermission() async {
  var status = await Permission.contacts.status;
  if (!status.isGranted) {
    await Permission.contacts.request();
  }
}


Future<List<Contact>> fetchContacts() async {
  // First check and obtain permission
  await _getContactsPermission();

  // Fetch contacts (without filtering)
  Iterable<Contact> contacts = await ContactsService.getContacts();
  return contacts.toList();
}
