const FOLDER_ID = 'COLE_AQUI_O_ID_DA_PASTA_DO_DRIVE';
const ACCESS_TOKEN = 'troque-este-token';

function jsonResponse(data, status) {
  return ContentService
    .createTextOutput(JSON.stringify(Object.assign({ status: status || 200 }, data)))
    .setMimeType(ContentService.MimeType.JSON);
}

function doPost(e) {
  try {
    const payload = JSON.parse(e.postData.contents || '{}');
    if (payload.token !== ACCESS_TOKEN) {
      return jsonResponse({ error: 'Token invalido.' }, 403);
    }

    const bytes = Utilities.base64Decode(payload.data || '');
    const blob = Utilities.newBlob(
      bytes,
      payload.type || 'application/octet-stream',
      payload.name || 'arquivo'
    );

    const folder = DriveApp.getFolderById(FOLDER_ID);
    const file = folder.createFile(blob);
    file.setSharing(DriveApp.Access.ANYONE_WITH_LINK, DriveApp.Permission.VIEW);

    const id = file.getId();
    return jsonResponse({
      id,
      name: file.getName(),
      type: payload.type || blob.getContentType(),
      size: bytes.length,
      url: `https://drive.google.com/uc?export=view&id=${id}`,
      downloadUrl: `https://drive.google.com/uc?export=download&id=${id}`,
      webViewLink: file.getUrl()
    });
  } catch (error) {
    return jsonResponse({ error: String(error && error.message ? error.message : error) }, 500);
  }
}
