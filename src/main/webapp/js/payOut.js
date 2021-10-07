
// add - start
let select_id = 0
$('#payOut-add-form').submit( ( event ) =>{
    event.preventDefault();

    const payOutTitle = $("#payOutTitle").val()
    const payOutType = $("#payOutType").val()
    const payOutTotal = $("#payOutTotal").val()
    const payOutDetail = $("#payOutDetail").val()

    const obj = {
        payOutTitle: payOutTitle,
        payOutType: payOutType,
        payOutTotal: payOutTotal,
        payOutDetail: payOutDetail
    }

    if ( select_id != 0 ){
        // update
        obj["payOut_id"] = select_id;
    }
    $.ajax({
        url: './payOut-post',
        type: 'POST',
        data: { obj: JSON.stringify(obj)},
        dataType: 'JSON',
        success: function (data){
            if(data > 0){
                alert("İşlem Başarılı")
                fncReset();
            }else {
                alert("İşlem sırasında hata oluştu!");
            }
        },
        error: function (err){
            console.log(err)
            alert("İşlem işlemi sırasında bir hata oluştu!");
        }
    })


} )
// add - end

// all payOut list - start
function allPayOut(){

    $.ajax({
        url: './payOut-get',
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
        const st = itm.payOutType == 0 ? 'Nakit' : itm.payOutType == 1 ? 'Kredi Kartı' : itm.payOutType == 2 ? 'Havale' : itm.payOutType == 3 ? 'EFT' : 'Banka Çeki'
        html += `<tr role="row" class="odd">
            <td>`+itm.payOut_id+`</td>
            <td>`+itm.payOutTitle+`</td>
            <td>`+st+`</td>
            <td>`+itm.payOutDetail+`</td>
            <td>`+itm.payOutTotal+`₺</td>
            <td class="text-right" >
              <div class="btn-group" role="group" aria-label="Basic mixed styles example">
                <button onclick="fncPayOutDelete(`+itm.payOut_id+`)" type="button" class="btn btn-outline-primary "><i class="far fa-trash-alt"></i></button>
                <button onclick="fncPayOutDetail(`+i+`)" data-bs-toggle="modal" data-bs-target="#payOutDetailModel" type="button" class="btn btn-outline-primary "><i class="far fa-file-alt"></i></button>
                <button onclick="fncPayOutUpdate(`+i+`)" type="button" class="btn btn-outline-primary "><i class="fas fa-pencil-alt"></i></button>
              </div>
            </td>
          </tr>`;
    }
    $('#tableRow').html(html);
}
allPayOut();
// all PayOut list - end

function fncReset(){
    select_id = 0;
    $('#payOut-add-form').trigger("reset");
    allPayOut();
}

//PayOut delete - start
function fncPayOutDelete ( payOut_id ){
    let answer = confirm("Silmek istediğinizden emin misiniz?");
    if ( answer ){
        $.ajax({
            url : ".//payOut-delete?payOut_id="+payOut_id,
            type : 'DELETE',
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
// PayOut delete - end

// PayOut update select
function fncPayOutUpdate( i ){
    const itm = globalArr[i];
    select_id = itm.payOut_id;
    $("#payOutTitle").val(itm.payOutTitle)
    $("#payOutType").val(itm.payOutType)
    $("#payOutTotal").val(itm.payOutTotal)
    $("#payOutDetail").val(itm.payOutDetail)
}

function fncPayOutDetail( i ){
    const itm = globalArr[i];
    $("#payOut_title").text(itm.payOutTitle.toUpperCase() + " - " + itm.payOut_id);
    $("#payOut_type").text(itm.payOutType == 0 ? 'Nakit' : itm.payOutType == 1 ? 'Kredi Kartı' : itm.payOutType == 2 ? 'Havale' : itm.payOutType == 3 ? 'EFT' : 'Banka Çeki');
    $("#payOut_total").text(itm.payOutTotal + "₺")
    $("#payOut_detail").text(itm.payOutDetail == "" ? '------' : itm.payOutDetail);

}

















