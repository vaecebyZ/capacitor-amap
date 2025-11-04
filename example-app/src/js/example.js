import { CapacitorAMap } from '@vaecebyz/capacitor-amap';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    console.log(inputValue)
    console.log(CapacitorAMap)
    CapacitorAMap.echo("1232132")
    CapacitorAMap.checkPermissions()
    CapacitorAMap.requestPermissions()
    CapacitorAMap.locate()
}
