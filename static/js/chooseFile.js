document.addEventListener('DOMContentLoaded', function() {
    var fileInput = document.getElementById('fileInput');
    var uploadButton = document.getElementById('uploadButton');

    fileInput.addEventListener('change', function(e) {
        var selectedFile = e.target.files[0];
        console.log('已选择文件:', selectedFile);
    });

    uploadButton.addEventListener('click', function() {
        fileInput.click(); // 手动触发文件选择对话框
    });
});