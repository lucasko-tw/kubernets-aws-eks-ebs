
CMD=CMD_NOT_DEFINED

debug_all:
	 kubectl get sc,pv,pvc,all

kube_apply:
	 kubectl apply -f test-pv.yml
	 kubectl apply -f test-pvc.yml
	 kubectl apply -f test-mysql-deployment.yml
	 #kubectl apply -f test-mysql-service.yml

kube_delete:
	 #kubectl delete -f test-mysql-service.yml
	 kubectl delete -f test-mysql-deployment.yml
	 kubectl delete -f test-pvc.yml
	 kubectl delete -f test-pv.yml




