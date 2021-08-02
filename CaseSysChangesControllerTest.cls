@isTest
public with sharing class CaseSysChangesControllerTest {
  /***** Test data setup *****/
  @TestSetup
  static void createCase() {
    // Contact con = new Contact();
    //  con
    // generate and insert a test case
    Case c = new Case();
    // c.ContactId = '0034C00000OT8ApQAL'; /***** USE THE ID OF THE CREATED CONTACT */
    c.Affected_System_Global__c = 'Marketing/Communications Team';
    c.Affected_system__c = 'Campaign/Graphic Design Suite';
    c.Subject = 'Test Case';

    insert c;
  }

  /***** Test for the correct rec type *****/
  @isTest
  public static void getSysChangesTest_CorrectRecType() {
    // Query the test case inserted by the @TestSetup method and assign it to a list
    // WHY: to use as sys changes' parent case in the code below
    List<Case> insertedCases = [SELECT Id FROM Case];

    // Get the Id of the System Change record type we need, using its developer name.
    // WHY: to avoid hardcoding the ID because IDs can change between sb and prod
    Id recTypeId = Schema.SObjectType.System_Change__c.getRecordTypeInfosByDeveloperName()
      .get('MarCom_Secondary_Sys_Change')
      .getRecordTypeId();

    // generate and insert test system changes
    List<System_Change__c> sysChanges = new List<System_Change__c>();
    for (integer i = 0; i < 5; i++) {
      System_Change__c sc = new System_Change__c();
      sc.Type_of_Change__c = 'Advertising Plan';
      sc.Target_Completion_Date__c = Date.today();
      sc.Description_of_Change__c = 'Test Sys Change ' + i;
      sc.RecordTypeId = recTypeId;
      sc.Case__c = insertedCases[0].Id;
      sysChanges.add(sc);
    }
    insert sysChanges;

    // Create an instance of the VF controller class.
    // WHY: the method that we need to invoke for testing is not static --
    // therefore, we cannot invoke it directly.
    CaseSysChangesController cscc = new CaseSysChangesController();

    // Assign the Id of the inserted test case to the caseId variable
    cscc.caseId = insertedCases[0].Id;

    // To test, invoke the "getSysChanges" class and assign the returned sys changes to a list
    Test.StartTest();
    List<System_Change__c> insertedSysChanges = cscc.getSysChanges();
    Test.StopTest();

    //Assert: make sure the list has the same number of members that were created
    System.assertEquals(
      5,
      insertedSysChanges.Size(),
      'Number of sys changes should be 5'
    );
  }

  /***** Test for the incorrect rec type *****/
  @isTest
  public static void getSysChangesTest_IncorrectRecType() {
    // Query the test case inserted by the @TestSetup method and assign it to a list
    // WHY: to use as sys changes' parent case in the code below
    List<Case> insertedCases = [SELECT Id FROM Case];

    // Get the Id of the incorrect System Change record type, using its developer name.
    // WHY: to avoid hardcoding the ID because IDs can change between sb and prod
    Id recTypeId = Schema.SObjectType.System_Change__c.getRecordTypeInfosByDeveloperName()
      .get('Marcom_Primary_Sys_Change')
      .getRecordTypeId();

    // generate and insert test system changes
    List<System_Change__c> sysChanges = new List<System_Change__c>();
    for (integer i = 0; i < 5; i++) {
      System_Change__c sc = new System_Change__c();
      sc.Type_of_Change__c = 'Advertising Plan';
      sc.Target_Completion_Date__c = Date.today();
      sc.Description_of_Change__c = 'Test Sys Change ' + i;
      sc.RecordTypeId = recTypeId;
      sc.Case__c = insertedCases[0].Id;
      sysChanges.add(sc);
    }
    insert sysChanges;

    // Create an instance of the VF controller class.
    // WHY: the method that we need to invoke for testing is not static --
    // therefore, we cannot invoke it directly.
    CaseSysChangesController cscc = new CaseSysChangesController();

    // Assign the Id of the inserted test case to the caseId variable
    cscc.caseId = insertedCases[0].Id;

    // To test, invoke the "getSysChanges" class and assign the returned sys changes to a list
    Test.StartTest();
    List<System_Change__c> insertedSysChanges = cscc.getSysChanges();
    Test.StopTest();

    //Assert: make sure the list has the same number of members that were created
    System.assertEquals(
      0,
      insertedSysChanges.Size(),
      'Number of sys changes should be zero'
    );
  }
}
