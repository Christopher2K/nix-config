import { cx } from "../../lib/utils";

type ContainerProps = {
  className?: string;
  left?: JSX.Element | JSX.Element[];
  children?: JSX.Element | JSX.Element[];
};

export const Container = ({ className, left, children }: ContainerProps) => {
  return (
    <box class={cx(className, "container")} vexpand>
      {left && <box class="left">{left}</box>}
      <box class={cx("right", left && "withLeft")}>{children}</box>
    </box>
  );
};
