import Network from "gi://AstalNetwork";
import { createBinding, createComputed } from "gnim";
import { Container } from "../components/container";

export const WifiWidget = () => {
  const network = Network.get_default();
  const ap = createBinding(network, "wifi", "activeAccessPoint");
  const wifiEnabled = createBinding(network, "wifi", "enabled");

  const icon = createComputed(() => {
    if (!wifiEnabled() || !ap()) return "󰖪";
    return "󰖩";
  });

  return <Container leftIcon={<label class="text-icon" label={icon} />} />;
};
