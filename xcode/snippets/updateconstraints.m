---
title: "updateConstraints"
completion-scopes:
  - ClassImplementation
---

- (void)updateConstraints {
  if (!self.didSetupConstraints) {
    
    self.didSetupConstraints = YES;
  }
  
  [super updateConstraints];
}
