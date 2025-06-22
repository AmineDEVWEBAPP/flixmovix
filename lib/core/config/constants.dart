import 'package:flutter/material.dart';

import 'theme.dart';

final BoxDecoration itemCardDecoration = BoxDecoration(
  color: AppTheme().instance.theme.colorScheme.secondaryContainer,
  boxShadow: [
    BoxShadow(
      color: AppTheme().instance.theme.shadowColor,
      blurRadius: 2,
      spreadRadius: 2.5,
    )
  ],
  borderRadius: BorderRadius.circular(10),
  border: Border.all(
    color: AppTheme().instance.theme.colorScheme.tertiary,
  ),
);

const String errorImageLink =
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJQAAACUCAMAAABC4vDmAAAAOVBMVEXg4ODj4+NycnJubm6ysrLHx8eRkZHc3Ny9vb2ioqKMjIx1dXW1tbXT09N+fn6qqqqXl5fNzc1paWklYHFdAAABZ0lEQVR4nO3YzXLDIAxGUSQbjMH4J+//sCUZmthtsupCTOeeRSZZ+RuhCLBzAAAAAAAAAAAAAAAA+Beksc7xIm6Kc0gpzHFyfeSSyQcd9GHQ4KcOYsmxZ801T6X1S94P+1RxrRXKYfGl+CXUdLpG61RjjbFu5dHj9aNsNWMeTVNJzFmTP2UQnzRny1rJUeuyt85u80CmvdbOsK/uz08t0xHj0VKle1KrTOKzrm3tZLzdWiuJXzV7s1IF1a09XEbV7/6WTTVYhZo0r8X9DuVKbX+j9ZM4vApyCSV1xBv9AWVWXd6HWlRno1C1Hv59KD9YNZUkHcrzxzmUK4OmLkI9R4JtqMvyHeN49LB850Z353OnZaOfR8I1lN1IuA/P/Byeftt8B8PzxzbzanTTbabPDbnHo0ufh7wPx2E1PQ67Li8Ors8r1uUyOvRyGe3y2u6uLzi6evHS3asgAAAAAAAAAAAAAAAA/MUXXpML1auBumgAAAAASUVORK5CYII=';
