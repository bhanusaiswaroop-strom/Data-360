public class ContactHandler {

    public static void contactduplicateonaccount(List<Contact> conlist) {

        Set<Id> accids = new Set<Id>();
        Set<String> emails = new Set<String>();
        Set<String> processed = new Set<String>();

        // Collect Account IDs and Emails
        for (Contact con : conlist) {

            if (con.AccountId != null && con.Email != null) {
                accids.add(con.AccountId);
                emails.add(con.Email.toLowerCase().trim());
            }
        }

        if (accids.isEmpty() || emails.isEmpty()) {
            return;
        }

        // Get existing Contacts
        List<Contact> existingcontacts = [
            SELECT Id, AccountId, Email
            FROM Contact
            WHERE AccountId IN :accids
            AND Email IN :emails
        ];

        // Check duplicates
        for (Contact con : conlist) {

            if (con.AccountId != null && con.Email != null) {

                String key = con.AccountId + '-' + con.Email.toLowerCase().trim();

                Boolean duplicateFound = false;

                // Check database records
                for (Contact existingcon : existingcontacts) {

                    if (con.AccountId == existingcon.AccountId &&
                        con.Email.equalsIgnoreCase(existingcon.Email) &&
                        con.Id != existingcon.Id) {

                        duplicateFound = true;
                        break;
                    }
                }

                // Check incoming records in the same batch
                if (processed.contains(key)) {
                    duplicateFound = true;
                }

                if (duplicateFound) {
                    con.addError('A Contact with this Email already exists under this Account.');
                }
                else {
                    processed.add(key);
                }
            }
        }
    }
}