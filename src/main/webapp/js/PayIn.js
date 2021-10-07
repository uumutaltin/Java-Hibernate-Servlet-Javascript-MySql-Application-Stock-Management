let selectedVoucher;
let paymentTotal = [];
let maxNumber;
let customerSelect;
let globalxVoucher;
let globalObj;
let globalArr = []

// all PayIn - start
allPayIn();
function allPayIn(){
    $.ajax({
        url: './payIn-get',
        type: 'GET',
        dataType: 'JSON',
        success: function (data) {
            createRow(data);
        },
        error: function (err) {
            console.log(err)
        }
    });

}

function createRow(data){
    globalArr = data;
    let html = ``
    for (let i = 0; i < data.length; i++) {
        const itm = data [i];
        html += `<tr role="row" class="odd">
             <td>` + i + `</td>
             <td>` + itm.cu_name + `</td>
             <td>` + itm.cu_surname + `</td>
             <td>` + itm.box_receipt + `</td>
             <td>` + itm.receipt_total + ` ₺</td>
             <td class="text-right" >
               <div class="btn-group" role="group" aria-label="Basic mixed styles example">
                <button onclick="fncReceiptDetail(`+i+`)"  data-bs-toggle="modal" data-bs-target="#receiptDetailModel" type="button" class="btn btn-outline-primary "><i class="far fa-file-alt"></i></button>
               </div>
             </td>
            </tr>`;
    }
    $('#tableRow').html(html);
}
// all PayIn - end

// PayIn detail - start
function fncReceiptDetail(id){

    let itm = globalArr[id];
    $('#box_receipt').text( "Fiş No: " + itm.box_receipt );
    $('#customer').text(itm.cu_name + " " + itm.cu_surname);
    $('#paid_amount').text(itm.receipt_total + " ₺");
    $('#rdetail').text(itm.payment_detail);
}
// PayIn detail - end



// PayIn add - start
$('#payIn_add_form').submit((event) => {
    event.preventDefault();
    const cID = $("#cid").val()
    const rID = $("#rname").find('option:selected').attr('id');
    const cName = $("#cid").find('option:selected').attr('id');
    const payInTotal = $("#payInTotal").val()
    const payInDetail = $("#payInDetail").val()
    console.log(cID, rID, payInTotal, payInDetail);
    const obj = {
        cName: cName,
        receipt_id: rID,
        payIn_amount: payInTotal,
        payment_detail: payInDetail
    };

    $.ajax({
        url: './payIn-post',
        type: 'POST',
        dataType: 'JSON',
        data: {obj: JSON.stringify(obj)},
        success: function (data) {
            alert("Başarılı!")
            location.reload();
        },
        error: function (err) {
            console.log(err)
        }
    })
});

$("#cid").change( function (){
    getCuReceipt(this.value)
    customerSelect = this.value;
})
// PayIn add - end



// Selected Customer Receipt GET - Start
function getCuReceipt(cid) {

    $.ajax({
        url: './receiptTotal-get?cid=' + cid,
        type: 'GET',
        dataType: 'JSON',
        success: function (data) {
            setReceipt(data)
            paymentTotal = data;
        },
        error: function (err) {
            console.log(err)
        }
    })
}
function setReceipt(data){
    console.log(data);

    $("#rname").find('option').remove();
    $('#rname').append("<option value=" + 0 + " data-subtext=" + ">Seçim Yapınız</option>")

    for (let i = 0; i < data.length; i++) {
        const item = data[i];
        if(item.join_receipt_total != item.receipt_payment)
            $('#rname').append("<option id='"+item.receipt_id+"' value=" + item.join_receipt + " data-subtext=  'Toplam: "  + item.join_receipt_total + " ₺'>" + item.join_receipt + "</option>");
    }

    $('#rname').val(0);
    $('#rname').selectpicker("refresh");
    selectedVoucher = 0;

}
$("#rname").change( function (){
    selectedVoucher = this.value
    changeMaxNumber();


})
// Selected Customer Receipt GET - End

// Receipt Max Value - Start
function changeMaxNumber(){
    if (selectedVoucher > 0) {
        $.ajax({
            url: './receipt-get?cid=' + customerSelect + '&join_receipt=' + selectedVoucher,
            type: 'GET',
            dataType: 'JSON',
            success: function (data) {
                console.log(data);
                if (data) {
                    globalxVoucher = data;
                    changeMaxNumberContinue(1);
                } else {
                    alert("Boş giriş mevcut...")
                }
            },
            error: function (err) {
                console.log(err)
            }
        })
    } else {
        changeMaxNumberContinue(0)
    }
}
function changeMaxNumberContinue(x) {
    if (x == 1) {
        const data = globalxVoucher;
        maxNumber = parseInt(data.join_receipt_total) - parseInt(data.receipt_payment);
        $("#payInTotal").attr("max", maxNumber);
        $("#payInTotal").val(maxNumber);
    } else if (x == 0) {
        globalxVoucher = 0;
        maxNumber = 1;
        $("#payInTotal").attr("max", maxNumber);
        $("#payInTotal").val(maxNumber);
    }
}
// Receipt Max Value - End


//PayInTotal min-max value set - start
$("#payInTotal").keyup(function () {
    $("#payInTotal").attr("min", 1);
    if (maxNumber != 0) {
        $("#payInTotal").attr("max", maxNumber);
    } else {
        $("#payInTotal").attr("max", 1);
    }

    const value = $("#payInTotal").val();
    if (value < 1) {
        $("#payInTotal").val(1);
    } else if (value > maxNumber) {
        $("#payInTotal").val(maxNumber);
    }
})
//PayInTotal min-max value set - end

// search - start

// Search - not used
$("#search").keyup(function (){

payInSearch();

    function payInSearch(){

        const search = $("#search").val();

        if(search !=""){

            $.ajax({
                url: './payIn-search-get?search='+search,
                type: 'GET',
                dataType: 'Json',
                success: function (data) {
                    createRow2(data);
                    console.log(data)
                },
                error: function (err) {
                    console.log(err)
                }
            })
        }else {
            allPayIn();
        }
    }

    function createRow2( data ){
        globalArr = data;
        let html = ``
        for (let i = 0; i < data.length; i++) {
            const itm = data[i];
            html += `<tr role="row" class="odd">
             <td>` + i + `</td>
             <td>` + itm.cu_name + `</td>
             <td>` + itm.cu_surname + `</td>
             <td>` + itm.box_receipt + `</td>
             <td>` + itm.receipt_total + ` ₺</td>
             <td class="text-right" >
               <div class="btn-group" role="group" aria-label="Basic mixed styles example">
                <button onclick="fncReceiptDetail(`+i+`)"  data-bs-toggle="modal" data-bs-target="#receiptDetailModel" type="button" class="btn btn-outline-primary "><i class="far fa-file-alt"></i></button>
               </div>
             </td>
            </tr>`;
        }
        $('#tableRow').html(html);
    }
})
//


