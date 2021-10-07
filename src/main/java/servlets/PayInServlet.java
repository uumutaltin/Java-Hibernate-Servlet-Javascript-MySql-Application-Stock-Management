package servlets;

import com.google.gson.Gson;
import entities.PayIn;
import entities.PayInTable;
import entities.Receipt;
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
import java.util.List;

@WebServlet(name = "payInServlet", value = {"/payIn-get","/payIn-post","/payIn-delete"})
public class PayInServlet extends HttpServlet {

    SessionFactory sf = HibernateUtil.getSessionFactory();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int pid = 0;
        Session sesi = sf.openSession();
        Transaction tr = sesi.beginTransaction();
        try{
            String obj = req.getParameter("obj");
            Gson gson = new Gson();
            PayIn payIn = gson.fromJson(obj,PayIn.class);
            payIn.setPayIn_date(LocalDateTime.now());

            DBUtil util = new DBUtil();
            Receipt r = util.singleReceipt(payIn.getReceipt_id());

            if( r.getReceipt_total() > r.getReceipt_payment()+ payIn.getPayIn_amount() ){
                r.setReceipt_payment( r.getReceipt_payment()+ payIn.getPayIn_amount());
            }else {
                r.setReceipt_payment(r.getReceipt_total());
            }
            sesi.update(r);


            sesi.save(payIn);
            tr.commit();
            pid=1;
        }catch (Exception ex){
            System.err.println("Save Or Update Error : " + ex);
        }finally {
            sesi.close();
        }
        resp.setContentType("application/json");
        resp.getWriter().write( "" +pid);


    }


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    Gson gson = new Gson();
    Session sesi = sf.openSession();
    List<PayInTable> ls = sesi.createNativeQuery("select r.receipt_id,c.cu_id,c.cu_name,c.cu_surname,r.receipt_total, p.payIn_amount, p.payIn_date,p.payment_detail,bo.box_receipt from receipt as r\n" +
                    "INNER JOIN payin as p\n" +
                    "on r.receipt_id = p.receipt_id\n" +
                    "INNER JOIN receipt_boxaction as rb\n" +
                    "on r.receipt_id = rb.Receipt_receipt_id\n" +
                    "INNER JOIN boxaction as bo\n" +
                    "on rb.boxActions_box_id = bo.box_id\n" +
                    "INNER JOIN customer as c\n" +
                    "on bo.customer_cu_id = c.cu_id\n" +
                    "GROUP BY r.receipt_id")
            .addEntity(PayInTable.class)
            .getResultList();
    sesi.close();
    String stJson = gson.toJson(ls);
    resp.setContentType("application/json");
    resp.getWriter().write(stJson);




    }
}
