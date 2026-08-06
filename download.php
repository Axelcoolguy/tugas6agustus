<?php
include "koneksi.php";

if (isset($_GET['id_file'])) {
    $id = $_GET['id_file'];
    $query = mysqli_query($koneksi, "SELECT * FROM t_file WHERE id_file='$id'");
    $data = mysqli_fetch_array($query);

    if ($data) {
        $filepath = "file/" . $data['nama_file'];

        if (file_exists($filepath)) {
            header('Content-Description: File Transfer');
            header('Content-Type: application/octet-stream');
            header('Content-Disposition: attachment; filename="' . basename($filepath) . '"');
            header('Expires: 0');
            header('Cache-Control: must-revalidate');
            header('Pragma: public');
            header('Content-Length: ' . filesize($filepath));
            readfile($filepath);
            exit;
        } else {
            echo "File tidak ditemukan di server.";
        }
    }
}
?>