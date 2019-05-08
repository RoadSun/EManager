var width = 400;
var height = 300;

var view_angle = 45;
aspect = width / height;
near = 0.1
far = 10000;

var $container = $("#container")
var render = new THREE.WebGLRenderbuffer();
var camera =
        new THREE.PerspectiveCamera(
        view_angle, aspect, near, far
        );
    var scene = new THREE.Scene();
 
    //把相机添加到场景里面
    scene.add(camera);
 
    camera.position.z = 300;
 
    renderer.setSize(width, height);
 
    //附加DOM元素
    $container.append(renderer.domElement);
 
    //设置球体的值
    var radius = 50, segemnt = 16, rings = 16;
 
    var sphereMaterial = new THREE.MeshLambertMaterial({ color: 0xCC0000 });
 
    var sphere = new THREE.Mesh(
        new THREE.SphereGeometry(radius,segemnt,rings),
        sphereMaterial
        );
 
    sphere.geometry.verticesNeedUpdate = true;
    sphere.geometry.normalsNeedUpdate = true;
 
    scene.add(sphere);
 
    var pointLight = new THREE.PointLight(0XFFFFFF);
 
    pointLight.position.x = 10;
    pointLight.position.y = 50;
    pointLight.position.z = 150;
 
    scene.add(pointLight);
 
     
    //画图
    renderer.render(scene, camera);
