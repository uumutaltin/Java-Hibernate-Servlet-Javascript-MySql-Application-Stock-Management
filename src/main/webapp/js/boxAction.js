// add - start
let select_id = 0
$('#boxAction_add_form').submit((event) => {
    event.preventDefault();
    const cname = $("#cname").val()
    const pname = $("#pname").children(":selected").attr("id");
    const count = $("#count").val()
    const bNo = $("#bNo").val()


    const obj = {
        box_customer_id: cname,
        box_product_id: pname,
        box_count: count,
        box_receipt: bNo,
        box_status: 0
    }

    if (select_id != 0) {
        obj["box_id"] = select_id;
    }
    $.ajax({
        url: './boxAction-post',
        type: 'POST',
        data: {obj: JSON.stringify(obj)},
        dataType: 'JSON',
        success: function (data) {
            if (data > 0) {
                $("#pname").val(parseInt($("#pname").val()) - parseInt(count));
                alert("Sepete Eklendi")
                allBox(cname);

            } else {
                alert("İşlem sırasında hata oluştu!");
            }
        },
        error: function (err) {
            console.log(err)
            alert("İşlem sırasında hata oluştu!")
        }
    })
})
// add - end

function codeGenerator() {
    const date = new Date();
    const time = date.getTime();
    const random = Math.floor(Math.random() * 10);
    return random.toString() + time.toString().substring(5);

}

// all box
function allBox(cid) {
    console.log("z");
    $.ajax({
        url: './boxAction-get?cid=' + cid,
        type: 'GET',
        dataType: 'JSON',
        success: function (data) {
            createRow(data);
        },
        error: function (err) {
            console.log(err)
        }
    })
}

let globalArr = []
let receipt_no = 0;

function createRow(data) {
    globalArr = data;
    let html = ``
    if(data.length == 0){
        $("#bNo").val(codeGenerator());
    }
    for (let i = 0; i < data.length; i++) {
        const itm = data[i];


        html += `<tr role="row" class="odd">
             <td>` + itm.box_id + `</td>
             <td>` + itm.pro_title + `</td>
             <td>` + itm.pro_sale_price + `₺</td>
             <td>` + itm.box_count + `</td>
             <td>` + itm.cu_name + `</td>
             <td>` + itm.box_receipt + `</td>
             <td class="text-right" >
               <div class="btn-group" role="group" aria-label="Basic mixed styles example">
                 <button onclick="fncBoxDelete(` + itm.box_id + `)" type="button" class="btn btn-outline-primary "><i class="far fa-trash-alt"></i></button>
               </div>
             </td>
            </tr>`;
    }
    if (globalArr.length > 0) {
        receipt_no = globalArr[0].box_receipt
        $("#bNo").val(receipt_no);
    }
    $('#tableRow').html(html);


}


$("#count").on("keyup", function() {
    const maxAmount = $("#pname").val()
    const value = $("#count").val();
  /*  if(value > maxAmount){
        $("#count").val(maxAmount);
    }*/
    if(value == 0){
        $("#count").val(1);
    }
});

$("#pname").on("change", function () {
    const amount = $("#pname").val()
    $("#count").attr("max", amount);
});

$("#cname").on("change", function () {
    allBox(this.value)
});

function fncBoxDelete(box_id) {
    const cname = $("#cname").val()
    let answer = confirm("Silmek istediğinizden emin misiniz?");
    if (answer) {
        $.ajax({
            url: './boxAction-delete?box_id=' + box_id,
            type: 'DELETE',
            dataType: 'text',
            success: function (data) {
                if (data != "0") {
                    alert("Silindi.")
                    allBox(cname);
                } else {
                    alert("Silme sırasında bir hata oluştu!");
                }
            },
            error: function (err) {
                console.log(err)
            }
        })
    }
}

$(document).on('click', '#completeOrder', function (data) {

    const obj = {
        box_receipt: receipt_no,
    }

    $.ajax({
        url: './receipt-post',
        type: 'POST',
        data: {obj: JSON.stringify(obj)},
        dataType: 'JSON',
        success: function (data) {
            if (data > 0) {
                alert("Sipariş tamamlandı")
                allBox($("#cname").val())

            } else {
                alert("İşlem sırasında hata oluştu!");
            }
        },
        error: function (err) {
            console.log(err)
            alert("İşlem sırasında hata oluştu!")
        }
    })

})

