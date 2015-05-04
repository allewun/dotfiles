---
title: "Lazy getter - UIView"
summary: "Lazy-loaded getter for UIView"
platform: iOS
completion-scope: Class Implementation
---

- (UIView *)<#name#> {
  _<#ivar#> = _<#ivar#> ?: ({
    UIView* view = [UIView new];
    <#initialization#>
    view;
  });

  return _<#ivar#>;
}