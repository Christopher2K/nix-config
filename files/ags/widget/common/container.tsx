import { cx } from "../../lib/utils";

type ContainerProps = {
  className?: string;
  left?: JSX.Element | JSX.Element[];
  children?: JSX.Element | JSX.Element[];
  rightContainerSpacing?: number;
};

export const Container = ({
  className,
  left,
  rightContainerSpacing,
  children,
}: ContainerProps) => {
  return (
    <box class={cx(className, "container")} vexpand>
      {left && <box class="left">{left}</box>}
      <box
        class={cx("right", left && "withLeft")}
        spacing={rightContainerSpacing}
      >
        {children}
      </box>
    </box>
  );
};
