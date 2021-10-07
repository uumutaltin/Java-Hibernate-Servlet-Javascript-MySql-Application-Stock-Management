package servlets;

import com.google.gson.Gson;
import entities.*;
import joins.JoinReceipt;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import utils.DBUtil;
import utils.HibernateUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "receiptServlet", value = {"/receipt-get","/receipt-post"})
public class ReceiptServlet extends HttpServlet {

    SessionFactory sf = HibernateUtil.getSessionFactory();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String obj = req.getParameter("obj");
        Gson gson = new Gson();
        JoinReceipt joinReceipt = gson.fromJson(obj, JoinReceipt.class);

        Session sesiUpdateStatus = sf.openSession();
        Transaction tr1 = sesiUpdateStatus.beginTransaction();
        int bid = 0;

        try {
            sesiUpdateStatus.createSQLQuery("CALL boxStatusChange(?)") //box items status change
                    .setParameter(1,joinReceipt.getBox_receipt())
                    .executeUpdate();
            tr1.commit();
            bid = 1;
        }catch (Exception ex){
            System.err.println("Update Statue Error : " + ex);
        }finally {
            sesiUpdateStatus.close();
        }

        if(bid == 1) {
            Session sesi = sf.openSession();
            Transaction tr = sesi.beginTransaction();
            try {
                DBUtil dbUtil = new DBUtil();

                List<BoxAction> boxActions = dbUtil.boxActionsList(joinReceipt.getBox_receipt());
                int total = 0;
                if (boxActions != null) {
                    for (BoxAction item : boxActions) {
                        total = total + (item.getProduct().getPro_sale_price() * item.getBox_count());
                    }
                    Receipt receipt = new Receipt();

                    receipt.setReceipt_total(total);
                    receipt.setDate(LocalDateTime.now());
                    receipt.setBoxActions(boxActions);
                    receipt.setReceipt_payment(0);

                    bid = (int) sesi.save(receipt);
                    tr.commit();
                }

            } catch (Exception ex) {
                System.err.println("Save Or Update Error : " + ex);
            } finally {
                sesi.close();
            }
        }

        resp.setContentType("application/json");
        resp.getWriter().write(""+bid);

    }


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        ReceiptTotal receiptTotal = new ReceiptTotal();
        Session sesi = sf.openSession();
        try {
            int cid = Integer.parseInt(req.getParameter("cid"));
            int join = Integer.parseInt(req.getParameter("join_receipt"));
           receiptTotal = (ReceiptTotal) sesi.createNativeQuery("select DISTINCT r.receipt_id, bo.box_receipt as join_receipt,\n" +
                           "r.receipt_total as join_receipt_total,\n" +
                           "r.receipt_payment\n" +
                           "from receipt as r\n" +
                           "INNER JOIN receipt_boxaction as rb\n" +
                           "on r.receipt_id = rb.Receipt_receipt_id\n" +
                           "INNER JOIN boxaction as bo\n" +
                           "on rb.boxActions_box_id = bo.box_id\n" +
                           "INNER JOIN customer as c\n" +
                           "on bo.customer_cu_id = c.cu_id\n" +
                           "where c.cu_id=?1 and bo.box_receipt=?2")

                            .setParameter(1,cid)
                            .setParameter(2,join)
                    .addEntity(ReceiptTotal.class)
                                    .getSingleResult();



        }catch (Exception ex){
            System.err.println("Error : " + ex);
        }finally {
            sesi.close();
        }
        Gson gson = new Gson();
        String stJson = gson.toJson(receiptTotal);
        resp.setContentType("application/json");
        resp.getWriter().write(stJson);



    }
}
