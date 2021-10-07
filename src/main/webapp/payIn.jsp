<%@ page import="entities.Admin" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="dbUtil" class="utils.DBUtil"></jsp:useBean>

<!doctype html>
<html lang="en">

<head>
  <title>Kasa Yönetimi / Ödeme Girişi</title>
  <jsp:include page="inc/css.jsp"></jsp:include>
</head>

<body>

<div class="wrapper d-flex align-items-stretch">
  <jsp:include page="inc/sideBar.jsp"></jsp:include>
  <div id="content" class="p-4 p-md-5">
    <jsp:include page="inc/topMenu.jsp"></jsp:include>
    <h3 class="mb-3">
      <a href="payOut.jsp" class="btn btn-danger float-right">Ödeme Çıkışı</a>
      Kasa Yönetimi
      <small class="h6">Ödeme Girişi</small>
    </h3>


    <div class="main-card mb-3 card mainCart">
      <div class="card-header cardHeader">Ödeme Ekle</div>

      <form class="row p-3" id="payIn_add_form">

        <div class="col-md-3 mb-3">
          <label for="cid" class="form-label">Müşteriler</label>
          <select id="cid" class="selectpicker" data-width="100%" data-show-subtext="true" data-live-search="true">
            <option data-subtext="">Seçim Yapınız</option>
            <c:forEach items="${dbUtil.allCustomer()}" var="item">
              <option id="${item.cu_name}"  value="${item.cu_id}" data-subtext="<c:out value="${item.cu_company_title}"></c:out>"><c:out value="${item.cu_name}"></c:out> <c:out value="${item.cu_surname}"></c:out></option>
            </c:forEach>
          </select>
        </div>

        <div class="col-md-3 mb-3">
          <label for="rname" class="form-label">Müşteri Fişleri</label>
          <select id="rname" class="selectpicker" data-width="100%" data-show-subtext="true" data-live-search="true">


          </select>
        </div>

        <div class="col-md-3 mb-3">
          <label for="payInTotal" class="form-label">Ödeme Tutarı</label>
          <input type="number" name="payInTotal" id="payInTotal" class="form-control" />
        </div>

        <div class="col-md-3 mb-3">
          <label for="payInDetail" class="form-label">Ödeme Detay</label>
          <input type="text" name="payInDetail" id="payInDetail" class="form-control" />
        </div>




        <div class="btn-group col-md-3 " role="group">
          <button type="submit" class="btn btn-outline-primary mr-1">Gönder</button>
          <button type="reset" class="btn btn-outline-primary">Temizle</button>
        </div>
      </form>
    </div>


    <div class="main-card mb-3 card mainCart">
      <div class="card-header cardHeader">Ödeme Giriş Listesi</div>

      <div class="row mt-3" style="padding-right: 15px; padding-left: 15px;">
        <div class="col-sm-3"></div>
        <div class="col-sm-3"></div>
        <div class="col-sm-3"></div>
        <div class="col-sm-3">

        </div>



      </div>
      <div class="table-responsive">
        <table class="align-middle mb-0 table table-borderless table-striped table-hover">
          <thead>
          <tr>
            <th>Id</th>
            <th>Adı</th>
            <th>Soyadı</th>
            <th>Fiş No</th>
            <th>Toplam Tutar</th>

            <th class="text-center" style="width: 155px;" >Yönetim</th>
          </tr>
          </thead>
          <tbody id="tableRow">
          <!-- for loop  -->
          <tr role="row" class="odd">
            <td class="text-right" >
              <div class="btn-group" role="group" aria-label="Basic mixed styles example">
                <button type="button" class="btn btn-outline-primary "><i class="far fa-file-alt"></i></button>
              </div>
            </td>
          </tr>
          </tbody>
        </table>
      </div>
    </div>
    <div class="modal fade" id="receiptDetailModel" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg" >
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" style="color: black"   id="box_receipt"></h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <div class="row ">
              <div class="col-md-6 mb-3">
                <label  class="form-label">Müşteri</label>
                <div style="color: black" id="customer" class="form-text">xx</div>
              </div>
              <div class="col-md-6 mb-3">
                <label  class="form-label">Toplam Tutar:</label>
                <div style="color: black" id="paid_amount" class="form-text">xx</div>
              </div>
              <div class="col-md-12 mb-3">
                <label  class="form-label">Detay:</label>
                <div style="color: black" id="rdetail" class="form-text">xx</div>
              </div>
            </div>

          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Kapat</button>

          </div>
        </div>
      </div>
    </div>


  </div>
</div>
</div>
<jsp:include page="inc/js.jsp"></jsp:include>
<script src="js/PayIn.js"></script>

</body>

</html>

