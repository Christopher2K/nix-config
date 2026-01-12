import AstalBattery from "gi://AstalBattery";
import { createBinding, createComputed } from "gnim";
import { Container } from "../common/container";

export const BatteryWidget = () => {
  const Battery = AstalBattery.get_default();
  const rawPercentage = createBinding(Battery, "percentage");
  const isCharging = createBinding(Battery, "charging");

  const percentage = createComputed(() => {
    return Math.round(rawPercentage() * 100);
  });
  const formattedPercentage = createComputed(() => {
    return `${percentage()}%`;
  });
  const iconClass = createComputed(() => {
    if (isCharging()) return "battery-good";
    if (percentage() <= 100 && percentage() > 60) {
      return "battery-good";
    }
    if (percentage() <= 60 && percentage() > 25) {
      return "battery-medium";
    }
    if (percentage() <= 25) {
      return "battery-critical";
    }
  });
  const icon = createComputed(() => {
    if (isCharging()) return "󰂄";

    if (percentage() <= 100 && percentage() > 80) {
      return "";
    } else if (percentage() <= 80 && percentage() > 50) {
      return "";
    } else if (percentage() <= 50 && percentage() > 25) {
      return "";
    } else if (percentage() <= 25 && percentage() > 10) {
      return "";
    } else {
      return "";
    }
  });

  return (
    <Container
      className="battery-widget"
      left={<label class={`text-icon ${iconClass}`} label={icon} />}
    >
      <label label={formattedPercentage} />
    </Container>
  );
};
