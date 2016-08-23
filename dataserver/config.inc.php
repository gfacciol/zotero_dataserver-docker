<?
class Z_CONFIG {
  public static $API_ENABLED = true;
  public static $SYNC_ENABLED = true;
  public static $PROCESSORS_ENABLED = true;
  public static $MAINTENANCE_MESSAGE = 'Server updates in progress. Please try again in a few minutes.';

 public static $TESTING_SITE = false;
 public static $DEV_SITE = false;

  public static $DEBUG_LOG = false;

 public static $BASE_URI = 'http://zotero.org/';
 public static $API_BASE_URI = 'https://localhost/';
  public static $WWW_BASE_URI = '';
 public static $SYNC_DOMAIN = 'sync';

 public static $AUTH_SALT = 'sometext';
 public static $API_SUPER_USERNAME = 'someusername';
 public static $API_SUPER_PASSWORD = 'somepassword';

  public static $AWS_ACCESS_KEY = '';
 public static $AWS_SECRET_KEY = 'yoursecretkey';
 public static $S3_BUCKET = 'zotero';
 public static $S3_ENDPOINT = 'localhost';
 public static $S3_USE_SSL = true;
 public static $S3_VALIDATE_SSL = false;

 public static $URI_PREFIX_DOMAIN_MAP = array(
   '/sync/' => 'sync'
 );

  public static $MEMCACHED_ENABLED = true;
  public static $MEMCACHED_SERVERS = array(
   'localhost:11211'
  );

  public static $TRANSLATION_SERVERS = array(
    "translation1.localdomain:1969"
  );

  public static $CITATION_SERVERS = array(
    "citeserver1.localdomain:8080", "citeserver2.localdomain:8080"
  );

  public static $ATTACHMENT_SERVER_HOSTS = array("files1.localdomain", "files2.localdomain");
  public static $ATTACHMENT_SERVER_DYNAMIC_PORT = 80;
  public static $ATTACHMENT_SERVER_STATIC_PORT = 81;
  public static $ATTACHMENT_SERVER_URL = "https://files.example.net";
  public static $ATTACHMENT_SERVER_DOCROOT = "/var/www/attachments/";

  public static $STATSD_ENABLED = false;
  public static $STATSD_PREFIX = "";
  public static $STATSD_HOST = "monitor.localdomain";
  public static $STATSD_PORT = 8125;

  public static $LOG_TO_SCRIBE = false;
  public static $LOG_ADDRESS = '';
  public static $LOG_PORT = 1463;
  public static $LOG_TIMEZONE = 'US/Eastern';
  public static $LOG_TARGET_DEFAULT = 'errors';

  public static $PROCESSOR_PORT_DOWNLOAD = 3455;
  public static $PROCESSOR_PORT_UPLOAD = 3456;
  public static $PROCESSOR_PORT_ERROR = 3457;

  public static $PROCESSOR_LOG_TARGET_DOWNLOAD = 'sync-processor-download';
  public static $PROCESSOR_LOG_TARGET_UPLOAD = 'sync-processor-upload';
  public static $PROCESSOR_LOG_TARGET_ERROR = 'sync-processor-error';

  public static $SYNC_DOWNLOAD_SMALLEST_FIRST = false;
  public static $SYNC_UPLOAD_SMALLEST_FIRST = false;

  // Set some things manually for running via command line
  public static $CLI_PHP_PATH = '/usr/bin/php';
 public static $CLI_DOCUMENT_ROOT = "/srv/zotero/dataserver/";

 public static $SYNC_ERROR_PATH = '/srv/zotero/log/sync-errors/';
 public static $API_ERROR_PATH = '/srv/zotero/log/api-errors/';

  public static $CACHE_VERSION_ATOM_ENTRY = 1;
  public static $CACHE_VERSION_BIB = 1;
  public static $CACHE_VERSION_ITEM_DATA = 1;
}
?>
