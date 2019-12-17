class Endpoints {
  static final String authenticate = '/api/v1/Auth/Authenticate';
  static final String checkAuthToken = '/api/v1/Auth/CheckAuthToken';
  static final String refreshAuth = '/api/v1/Auth/RefreshAuth';
  static final String clearAuth = '/api/v1/Auth/ClearAuth';

  static final String register = '/api/v1/Users/Register';
  static final String getCurrentUserInfo = '/api/v1/Users/GetCurrentUserInfo';
  static final String resendConfirmEmail = '/api/v1/Users/ResendConfirmEmail';
  static final String sendResetPasswordInfoToEmail = '/api/v1/Users/SendResetPasswordInfoToEmail';
  static final String updateUser = '/api/v1/Users/UpdateUser';

  static final String getAllIssueProperties = '/api/v1/OneSData/GetAllIssueProperties';
  static final String getLastActionByDeviceIdOrSerialNumber = '/api/v1/OneSData/GetLastActionByDeviceIdOrSerialNumber';
  
  static final String getAllIssuesPaged = '/api/v1/OkDesk/GetAllIssuesPaged';
  static final String getIssue = '/api/v1/OkDesk/GetIssue';
  static final String getComments = '/api/v1/OkDesk/GetComments';
  static final String addComment = '/api/v1/OkDesk/AddComment';
  static final String getAttachments = '/api/v1/OkDesk/GetAttachments';
  static final String addIssue = '/api/v1/OkDesk/AddIssue';
  static final String getAttachmentLink = '/api/v1/OkDesk/GetAttachmentLink';
  static final String getEmployee = '/api/v1/OkDesk/GetEmployee';
}
