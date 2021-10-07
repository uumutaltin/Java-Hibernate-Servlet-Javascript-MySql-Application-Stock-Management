// Product
// add- start
let select_id = 0
$('#product_add_form').submit( ( event ) => {
    event.preventDefault();

    const ptitle = $("#ptitle").val()
    const purchase_price = $("#purchase_price").val()
    const sale_price = $("#sale_price").val()
    const pcode = $("#pcode").val()
    const ptax = $("#ptax").val()
    const punit = $("#punit").val()
    const pamount = $("#pamount").val()
    const pdetail = $("#pdetail").val()

    const obj = {
        pro_title: ptitle,
        pro_purchase_price: purchase_price,
        pro_sale_price: sale_price,
        pro_code: pcode,
        pro_tax: ptax,
        pro_unit: punit,
        pro_amount: pamount,
        pro_detail: pdetail
    }

    if ( select_id != 0) {
        // update
        obj["pro_id"] = select_id;
    }
    $.ajax({
        url: './product-post',
        type: 'POST',
        data: { obj: JSON.stringify(obj) },
        dataType: 'JSON',
        success: function (data) {
            if( data > 0) {
                alert("İşlem Başarılı")
                fncReset();
            }else {
                alert("İşlem sırasında hata oluştu!");
            }
        },
        error: function (err) {
            console.log(err)
            alert("İşlem işlemi sırasında bir hata oluştu!");
        }
    })


} )
// add - end

// all product list - start
function allProduct(){

    $.ajax({
        url: './product-get',
        type: 'GET',
        dataType: 'JSON',
        success: function (data){
            createRow(data);
        },
        error: function (err){
            console.log(err)
        }
    })
}

let globalArr = []
function createRow( data ) {
    globalArr = data;
    let html = ``
    for (let i = 0; i < data.length; i++) {
        const itm = data [i];
        const st = itm.pro_tax ==  0  ? 'Dahil' : itm.pro_tax== 1 ?  '%1'  : itm.pro_tax== 2 ? '%8' : '%18'
        const st_unit =  itm.pro_unit == 0 ? 'Adet' : itm.pro_unit == 1 ? 'KG' : itm.pro_unit == 2 ? 'Metre' : itm.pro_unit == 3 ? 'Paket' : 'Litre'
        html += `<tr role="row" class="odd">
            <td>`+itm.pro_id+`</td>
            <td>`+itm.pro_title+`</td>
            <td>`+itm.pro_purchase_price+`₺</td>
            <td>`+itm.pro_sale_price+`₺</td>
            <td>`+itm.pro_code+`</td>
            <td>`+st+`</td>
            <td>`+st_unit+`</td>
            <td>`+itm.pro_amount+`</td>
            <td class="text-right" >
              <div class="btn-group" role="group" aria-label="Basic mixed styles example">
                <button onclick="fncProductDelete(`+itm.pro_id+`)" type="button" class="btn btn-outline-primary "><i class="far fa-trash-alt"></i></button>
                <button onclick="fncProductDetail(`+i+`)" data-bs-toggle="modal" data-bs-target="#productDetailModel" type="button" class="btn btn-outline-primary "><i class="far fa-file-alt"></i></button>
                <button onclick="fncProductUpdate(`+i+`)" type="button" class="btn btn-outline-primary "><i class="fas fa-pencil-alt"></i></button>
              </div>
            </td>
          </tr>`;
    }
    $('#tableRow').html(html);
}

function codeGenerator() {
    const date = new Date();
    const time = date.getTime();
    const key = time.toString().substring(4);
    $('#ccode').val( key )
    $('#pcode').val( key )
}
allProduct();
// all product list - end

function fncReset(){
    select_id = 0;
    $('#product_add_form').trigger("reset");
    codeGenerator();
    allProduct();
}
// product delete - start
function fncProductDelete ( pro_id ) {
    let answer = confirm("Silmek istediğinizden emin misiniz?");
    if ( answer ){
        $.ajax({
            url : "./product-delete?pro_id="+pro_id,
            type: 'DELETE',
            dataType: 'text',
            success: function (data){
                if( data != "0"){
                    fncReset();
                }else {
                    alert("Silme sırasında bir hata oluştu!");
                }
            },
            error: function (err) {
                console.log(err)
            }
        })
    }
}
// product delete - end

// product detail - start
function fncProductDetail(i){
    const itm = globalArr[i];
    $("#pro_title").text(itm.pro_title.toUpperCase() + " - " + itm.pro_id );
    $("#pro_purchase_price").text(itm.pro_purchase_price );
    $("#pro_sale_price").text(itm.pro_sale_price );
    $("#pro_code").text(itm.pro_code );
    $("#pro_tax").text(itm.pro_tax ==  0  ? 'Dahil' : itm.pro_tax== 1 ?  '%1'  : itm.pro_tax== 2 ? '%8' : '%18' );
    $("#pro_unit").text(itm.pro_unit == 0 ? 'Adet' : itm.pro_unit == 1 ? 'KG' : itm.pro_unit == 2 ? 'Metre' : itm.pro_unit == 3 ? 'Paket' : 'Litre' );
    $("#pro_amount").text(itm.pro_amount );
    $("#pro_detail").text(itm.pro_detail == "" ? '------' : itm.pro_detail);

}









// product update select
function fncProductUpdate( i ){
    const itm = globalArr[i];
    select_id = itm.pro_id;
    $("#ptitle").val(itm.pro_title)
    $("#purchase_price").val(itm.pro_purchase_price)
    $("#sale_price").val(itm.pro_sale_price)
    $("#pcode").val(itm.pro_code)
    $("#ptax").val(itm.pro_tax)
    $("#punit").val(itm.pro_unit)
    $("#pamount").val(itm.pro_amount)
    $("#pdetail").val(itm.pro_detail)
}