<?php
session_start();
if (!isset($_SESSION['username'])) {
    header("location:login.php");
    exit();
}

include 'koneksi.php';
$query = mysqli_query($koneksi, "SELECT * FROM barang_bukti");
?>

<!DOCTYPE html>
<html>
<head>
    <title>Data Barang Bukti</title>
</head>
<body>
    <div style="display: flex; justify-content: space-between; align-items: center;">
        <h2>Daftar Barang Bukti</h2>
        <a href="logout.php" onclick="return confirm('Yakin ingin logout?')"><button type="button">Logout</button></a>
    </div>

    <a href="input.php">+ Tambah Data</a><br><br>
    
    <table border="1" cellpadding="8" cellspacing="0">
        <tr>
            <th>ID</th>
            <th>Jenis Barang</th>
            <th>Nama Barang</th>
            <th>Jumlah</th>
            <th>Satuan</th>
            <th>Foto</th>
            <th>Aksi</th>
        </tr>
        <?php while ($d = mysqli_fetch_array($query)) : ?>
        <tr>
            <td><?= $d['id']; ?></td>
            <td><?= $d['jenis_barang']; ?></td>
            <td><?= $d['nama_barang']; ?></td>
            <td><?= $d['jumlah']; ?></td>
            <td><?= $d['satuan']; ?></td>
            <td>
                <img src="uploads/<?= $d['foto']; ?>" width="80"><br>
                <a href="download.php?file=<?= $d['foto']; ?>">Download</a>
            </td>
            <td>
                <a href="edit.php?id=<?= $d['id']; ?>">Edit</a> | 
                <a href="delete.php?id=<?= $d['id']; ?>" onclick="return confirm('Yakin hapus?')">Hapus</a>
            </td>
        </tr>
        <?php endwhile; ?>
    </table>
</body>
</html>
