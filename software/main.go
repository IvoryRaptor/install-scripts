package main

import (
	"flag"
	"os"
	"path/filepath"
	//"k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	// Uncomment the following line to load the gcp plugin (only required to authenticate against GKE clusters).
	// _ "k8s.io/client-go/plugin/pkg/client/auth/gcp"
	//"fmt"
	//"gopkg.in/yaml.v2"
	//"io/ioutil"
	"k8s.io/api/core/v1"
)

func modifyHost(){

}

func main() {
	var kubeconfig *string
	if home := homeDir(); home != "" {
		kubeconfig = flag.String("kubeconfig", filepath.Join(home, ".kube", "config"), "(optional) absolute path to the kubeconfig file")
	} else {
		kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
	}
	flag.Parse()

	// use the current context in kubeconfig
	config, err := clientcmd.BuildConfigFromFlags("", *kubeconfig)
	if err != nil {
		panic(err.Error())
	}

	// create the clientset
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err.Error())
	}

	nodes, err := clientset.CoreV1().Nodes().List(metav1.ListOptions{})
	if err != nil {
		panic(err.Error())
	}
	//data, err := ioutil.ReadFile(fmt.Sprintf(".config.yaml"))
	//if err != nil {
	//	return nil, err
	//}
	//err = yaml.Unmarshal(data, config)

	for _, node := range nodes.Items {
		println(node.Name)
		for _, address := range node.Status.Addresses {
			//if address.Type == v1.NodeHostName {
			//	println(address.Address)
			//}
			if address.Type == v1.NodeInternalIP {
				println(address.Address)
			}
		}
		//node.Labels["kafka"] = "true"
		//clientset.CoreV1().Nodes().Update(&node)
		//node.SetLabels(map[string]string{"kafka": "true"})
		//for key, value := range node.Labels {
		//	println(key, value)
		//}
	}
}

func homeDir() string {
	if h := os.Getenv("HOME"); h != "" {
		return h
	}
	return os.Getenv("USERPROFILE") // windows
}
