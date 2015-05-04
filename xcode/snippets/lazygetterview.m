---
title: "Lazy getter - UIView"
platform: iOS
completion-scopes:
  - ClassImplementation
---

- (UIView *)<#name#> {
  _<#ivar#> = _<#ivar#> ?: ({
    UIView* view = [UIView new];
    <#initialization#>
    view;
  });

  return _<#ivar#>;
}