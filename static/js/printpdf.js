document.addEventListener("DOMContentLoaded", function () {
    // 在这里放置你的代码

    document.getElementById("generate-pdf").addEventListener("click", function () {

        window.jsPDF = window.jspdf.jsPDF;
        // 创建一个新的jsPDF实例
        const doc = new jsPDF();

        doc.addFont('SourceHanSans-Normal.ttf', 'SourceHanSans-Normal', 'normal');
        doc.setFont('SourceHanSans-Normal');

        // 从HTML元素中提取文字内容
        var content = document.getElementById("pdf-content").innerText;

        // 将内容添加到PDF中
        doc.text(content, 10, 10);

        // 保存或打印PDF
        // doc.save("your-pdf-filename.pdf"); // 保存PDF文件
        // doc.autoPrint(); // 打印PDF

        // 如果你希望在生成PDF后立即下载，可以使用以下代码替代doc.save()：
        var blob = doc.output('blob');
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = 'your-pdf-filename.pdf';
        a.click();
    });

});