<?php
include 'koneksi.php';
$id = $_GET['id'];
$data = mysqli_fetch_array(mysqli_query($koneksi, "SELECT * FROM barang_bukti WHERE id='$id'"));

if (isset($_POST['update'])) {
    $jenis  = $_POST['jenis_barang'];
    $nama   = $_POST['nama_barang'];
    $jumlah = $_POST['jumlah'];

    if ($_FILES['foto']['name'] != "") {
        $foto      = $_FILES['foto']['name'];
        $tmp_name  = $_FILES['foto']['tmp_name'];
        $foto_baru = time() . '_' . $foto;
        
        // Hapus foto lama
        unlink("uploads/" . $data['foto']);
        move_uploaded_file($tmp_name, 'uploads/' . $foto_baru);
    } else {
        $foto_baru = $data['foto'];
    }

    mysqli_query($koneksi, "UPDATE barang_bukti SET jenis_barang='$jenis', nama_barang='$nama', jumlah='$jumlah', foto='$foto_baru' WHERE id='$id'");
    header("Location: index.php");
}
?>

<!DOCTYPE html>
<html>
<head><title>Edit Barang Bukti</title></head>
<body>
    <h2>Edit Data</h2>
    <form action="" method="POST" enctype="multipart/form-data">
        <label>Jenis Barang:</label><br>
        <input type="text" name="jenis_barang" value="<?= $data['jenis_barang']; ?>"><br><br>
        
        <label>Nama Barang:</label><br>
        <input type="text" name="nama_barang" value="<?= $data['nama_barang']; ?>"><br><br>
        
        <label>Jumlah:</label><br>
        <input type="number" name="jumlah" value="<?= $data['jumlah']; ?>"><br><br>
        
        <label>Foto Saat Ini:</label><br>
        <img src="uploads/<?= $data['foto']; ?>" width="100"><br><br>
        
        <label>Ganti Foto (Opsional):</label><br>
        <input type="file" name="foto"><br><br>
        
        <button type="submit" name="update">Update</button>
    </form>
</body>
</html>
