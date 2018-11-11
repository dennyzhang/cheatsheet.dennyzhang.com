String ip_hostname_list = """ 138.197.192.172  bematech-do-jenkins
   138.68.254.56  bematech-do-lb-1
  138.68.254.215  bematech-do-lb-2
   165.227.8.194  bematech-do-cb-01
  138.197.215.93  bematech-do-cb-02   """;

def l = ip_hostname_list.split("\n")
print l.join("a")
