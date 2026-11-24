trigger Contacttrigger on Contact (before insert,before update) {
    
    if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert))
       {
           ContactHandler.contactduplicateonaccount(Trigger.new);
       }
}