package com.example.culturepay.servlet;
receipt.append("총금액: ").append(p.getTotalAmount()).append("\n");
receipt.append("항목:\n");
for (PaymentItem it : finalP.getItems()) {
receipt.append(" - ").append(it.getTerminalBusinessNo()).append(" : ").append(it.getAmount()).append(" ("+it.getStatus()+")\n");
}
dao.saveReceipt(paymentId, receipt.toString());
} else {
dao.updatePaymentStatus(paymentId, "FAILED");
}


} catch (Exception ex) {
try { dao.updatePaymentStatus(paymentId, "FAILED"); } catch (SQLException ignored) {}
ex.printStackTrace();
}
});


// 클라이언트로 txId 전달 (클라이언트는 이 txId로 폴링)
resp.setContentType("application/json;charset=UTF-8");
resp.getWriter().write("{\"txId\": \"" + p.getTxId() + "\"}");


} catch (SQLException e) {
throw new ServletException(e);
}
}


// 항목별 결제 시뮬레이션 메소드
private void processItemSimulate(PaymentDAO dao, PaymentItem it) {
try {
// 상태 PROCESSING으로 변경
dao.updatePaymentItemStatus(it.getId(), "PROCESSING", null);

// 외부 PG 호출 시뮬레이션(여기서는 sleep)
Thread.sleep(2000);

// 무작위 성공/실패 (학습용)
boolean success = true; // 실제는 PG 응답으로 판별
if (success) {
dao.updatePaymentItemStatus(it.getId(), "SUCCESS", "SIMULATED_REF_" + UUID.randomUUID().toString());
} else {
dao.updatePaymentItemStatus(it.getId(), "FAILED", "SIMULATED_REF_" + UUID.randomUUID().toString());
}
} catch (Exception e) {
try { dao.updatePaymentItemStatus(it.getId(), "FAILED", null); } catch (SQLException ignored) {}
e.printStackTrace();
}
}
}
