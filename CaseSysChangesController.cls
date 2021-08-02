public class CaseSysChangesController {
  // Make caseId readable and editable by other code
  // WHY: to be used with the "assignTo" attribute in CaseSysChanges.component (a VF component)
  public Id caseId { get; set; }

  // Method that queries and returns System Changes related to the case that's being referenced in the VF email template
  public List<System_Change__c> getSysChanges() {
    // Get the Id of the System Change record type we need, using its developer name.
    // WHY: to avoid using the ID in the SOQL query because IDs can change between sb and prod
    Id recTypeId = Schema.SObjectType.System_Change__c.getRecordTypeInfosByDeveloperName()
      .get('MarCom_Secondary_Sys_Change')
      .getRecordTypeId();

    return [
      SELECT
        Name,
        Type_of_Change__c,
        Target_Completion_Date__c,
        Description_of_Change__c
      FROM System_Change__c
      WHERE RecordTypeId = :recTypeId AND Case__r.Id = :caseId
    ];
  }
}
