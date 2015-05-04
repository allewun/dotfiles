---
title: "Lazy getter - UIButton"
platform: iOS
completion-scopes:
  - ClassImplementation
---

- (UIButton *)<#name#> {
  _<#ivar#> = _<#ivar#> ?: ({
    UIButton* image = [UIButton new];
    <#initialization#>
    button;
  });

  return _<#ivar#>;
}