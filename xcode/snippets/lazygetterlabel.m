---
title: "Lazy getter - UILabel"
platform: iOS
completion-scopes:
  - ClassImplementation
---

- (UILabel *)<#name#> {
  _<#ivar#> = _<#ivar#> ?: ({
    UILabel* label = [UILabel new];
    <#initialization#>
    label;
  });

  return _<#ivar#>;
}