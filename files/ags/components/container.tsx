import { cx } from "../lib/utils";

type ContainerProps = {
  className?: string;
  leftIcon?: JSX.Element | JSX.Element[];
  content?: JSX.Element | JSX.Element[];
  rightContainerSpacing?: number;
};

export const Container = ({
  className,
  leftIcon,
  rightContainerSpacing,
  content,
}: ContainerProps) => {
  return (
    <box class={cx(className, "container")}>
      {leftIcon && (
        <box class={cx("left", content && "withContent")}>{leftIcon}</box>
      )}
      {content && (
        <box
          class={cx("right", leftIcon && "withLeft")}
          spacing={rightContainerSpacing}
        >
          {content}
        </box>
      )}
    </box>
  );
};
