<?php
include 'koneksi.php';

if (isset($_POST['submit'])) {
    $jenis  = $_POST['jenis_barang'];
    $nama   = $_POST['nama_barang'];
    $jumlah = $_POST['jumlah'];

    // File Upload
    $foto      = $_FILES['foto']['name'];
    $tmp_name  = $_FILES['foto']['tmp_name'];
    $foto_baru = time() . '_' . $foto;

    if (move_uploaded_file($tmp_name, 'uploads/' . $foto_baru)) {
        mysqli_query($koneksi, "INSERT INTO barang_bukti VALUES(NULL, '$jenis', '$nama', '$jumlah', '$foto_baru')");
        header("Location: index.php");
    }
}
?>

<!DOCTYPE html>
<html>
<head><title>Tambah Barang Bukti</title></head>
<body>
    <h2>Input Barang Bukti</h2>
    <form action="" method="POST" enctype="multipart/form-data">
        <label>Jenis Barang:</label><br>
        <input type="text" name="jenis_barang" required><br><br>
        
        <label>Nama Barang:</label><br>
        <input type="text" name="nama_barang" required><br><br>
        
        <label>Jumlah:</label><br>
        <input type="number" name="jumlah" required><br><br>
        
        <label>Foto Barang Bukti:</label><br>
        <input type="file" name="foto" required><br><br>
        
        <button type="submit" name="submit">Simpan</button>
    </form>
</body>
</html>
