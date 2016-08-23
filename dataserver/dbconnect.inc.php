<?
function Zotero_dbConnectAuth($db) {
        $charset = '';

        if ($db == 'master') {
                $host = 'localhost';
                $port = 3306;
                $db = 'zotero_master';
                $user = 'zotero';
                $pass = 'foobar';
        }
        else if ($db == 'shard') {
                $host = false;
                $port = false;
                $db = false;
                $user = 'zotero';
                $pass = 'foobar';
        }
        else if ($db == 'id1') {
                $host = 'localhost';
                $port = 3306;
                $db = 'zotero_ids';
                $user = 'zotero';
                $pass = 'foobar';
        }
        else if ($db == 'id2') {
                $host = 'localhost';
                $port = 3306;
                $db = 'zotero_ids';
                $user = 'zotero';
                $pass = 'foobar';
        }
        else {
                throw new Exception("Invalid db '$db'");
        }
        return array(
          'host'=>$host, 
          'port'=>$port, 
          'db'=>$db, 
          'user'=>$user, 
          'pass'=>$pass,
          'charset'=>$charset
        );
}
?>
